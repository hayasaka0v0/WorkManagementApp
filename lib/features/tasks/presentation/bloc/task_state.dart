part of 'task_bloc.dart';

/// Base class for all task states
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TaskInitial extends TaskState {}

/// Loading state
class TaskLoading extends TaskState {}

/// Loaded state with tasks
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Error state
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
