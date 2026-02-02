part of 'task_bloc.dart';

/// Base class for all task events
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks
class LoadTasksEvent extends TaskEvent {}

/// Event to create a new task
class CreateTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final String? companyId;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskVisibility visibility;
  final String? assigneeId;

  const CreateTaskEvent({
    required this.title,
    required this.description,
    this.companyId,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
    this.visibility = TaskVisibility.teamOnly,
    this.assigneeId,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    companyId,
    dueDate,
    priority,
    status,
    visibility,
    assigneeId,
  ];
}

/// Event to update an existing task
class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event to toggle task completion status
class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletionEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event to filter tasks
class FilterTasksEvent extends TaskEvent {
  final String? companyId;
  final List<TaskPriority>? priorities;
  final List<TaskVisibility>? visibilities;

  const FilterTasksEvent({this.companyId, this.priorities, this.visibilities});

  @override
  List<Object?> get props => [companyId, priorities, visibilities];
}
