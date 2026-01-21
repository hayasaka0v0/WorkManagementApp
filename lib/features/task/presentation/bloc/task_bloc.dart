import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/task/domain/entities/task.dart';
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
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await getTasks(const NoParams());

    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Allow task creation from any state
    emit(TaskLoading());

    final result = await createTask(
      CreateTaskParams(title: event.title, description: event.description),
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
      final updatedTasks = currentState.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      emit(TaskLoaded(updatedTasks));

      final result = await updateTask(event.task);

      result.fold(
        (failure) {
          // Revert on failure
          emit(TaskLoaded(currentState.tasks));
          emit(TaskError(failure.message));
        },
        (_) {
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
      final updatedTasks = currentState.tasks
          .where((task) => task.id != event.taskId)
          .toList();

      emit(TaskLoaded(updatedTasks));

      final result = await deleteTask(event.taskId);

      result.fold(
        (failure) {
          // Revert on failure
          emit(TaskLoaded(currentState.tasks));
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
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final task = currentState.tasks.firstWhere((t) => t.id == event.taskId);

      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

      add(UpdateTaskEvent(updatedTask));
    }
  }
}
