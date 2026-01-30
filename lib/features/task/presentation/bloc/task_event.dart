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
  final String companyId;
  final DateTime dueDate;
  final TaskPriority priority;
  final String? assigneeId;

  const CreateTaskEvent({
    required this.title,
    required this.description,
    required this.companyId,
    required this.dueDate,
    required this.priority,
    this.assigneeId,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    companyId,
    dueDate,
    priority,
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
