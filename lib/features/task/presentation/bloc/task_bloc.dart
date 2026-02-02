import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/domain/usecases/create_task.dart';
import 'package:learning/features/task/domain/usecases/delete_task.dart';
import 'package:learning/features/task/domain/usecases/get_tasks.dart';
import 'package:learning/features/task/domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

/// BLoC for managing task state
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  List<Task> _applyFilter(
    List<Task> tasks,
    String? companyId,
    List<TaskPriority>? priorities,
    List<TaskVisibility>? visibilities,
  ) {
    return tasks.where((task) {
      if (companyId != null && task.companyId != companyId) return false;
      if (priorities != null &&
          priorities.isNotEmpty &&
          !priorities.contains(task.priority)) {
        return false;
      }
      if (visibilities != null &&
          visibilities.isNotEmpty &&
          !visibilities.contains(task.visibility)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      // Use event values, treating them as the *new* state of the filter.
      // NOTE: This assumes the UI passes the *complete* desired filter state every time.
      // If we wanted "update only what changed", we'd need to check for "unset" vs "null".
      // For simplicity, we assume the UI manages the filter state object and passes it here.

      // If we want to allow partial updates, we would fallback to currentState.filterX
      // But clearing a filter (setting to null) would be impossible if we always fallback to current.
      // So we assume the event provides the FULL filter configuration.

      final filteredTasks = _applyFilter(
        currentState.allTasks,
        event.companyId,
        event.priorities,
        event.visibilities,
      );

      emit(
        TaskLoaded(
          allTasks: currentState.allTasks,
          tasks: filteredTasks,
          filterCompanyId: event.companyId,
          filterPriorities: event.priorities,
          filterVisibilities: event.visibilities,
        ),
      );
    }
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await getTasks(const NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(allTasks: tasks, tasks: tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Allow task creation from any state
    emit(TaskLoading());

    final result = await createTask(
      CreateTaskParams(
        title: event.title,
        description: event.description,
        companyId: event.companyId,
        dueDate: event.dueDate,
        priority: event.priority,
        status: event.status,
        visibility: event.visibility,
        assigneeId: event.assigneeId,
      ),
    );

    result.fold((failure) => emit(TaskError(failure.message)), (newTask) {
      // Reload tasks after creating
      add(LoadTasksEvent());
    });
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      // Optimistically update UI
      final updatedAllTasks = currentState.allTasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      final updatedTasks = _applyFilter(
        updatedAllTasks,
        currentState.filterCompanyId,
        currentState.filterPriorities,
        currentState.filterVisibilities,
      );

      emit(
        TaskLoaded(
          allTasks: updatedAllTasks,
          tasks: updatedTasks,
          filterCompanyId: currentState.filterCompanyId,
          filterPriorities: currentState.filterPriorities,
          filterVisibilities: currentState.filterVisibilities,
        ),
      );

      final result = await updateTask(event.task);

      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState); // Re-emit the exact previous state
          emit(TaskError(failure.message));
        },
        (_) {
          // Keep the optimistic update or reload to confirm
          // Reload to get fresh data from server
          add(LoadTasksEvent());
        },
      );
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      // Optimistically remove from UI
      final updatedAllTasks = currentState.allTasks
          .where((task) => task.id != event.taskId)
          .toList();

      final updatedTasks = _applyFilter(
        updatedAllTasks,
        currentState.filterCompanyId,
        currentState.filterPriorities,
        currentState.filterVisibilities,
      );

      emit(
        TaskLoaded(
          allTasks: updatedAllTasks,
          tasks: updatedTasks,
          filterCompanyId: currentState.filterCompanyId,
          filterPriorities: currentState.filterPriorities,
          filterVisibilities: currentState.filterVisibilities,
        ),
      );

      final result = await deleteTask(event.taskId);

      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState);
          emit(TaskError(failure.message));
        },
        (_) {
          // Keep the optimistic update
        },
      );
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    // TODO: Implement toggle logic if needed, or rely on UpdateTaskEvent
  }
}
