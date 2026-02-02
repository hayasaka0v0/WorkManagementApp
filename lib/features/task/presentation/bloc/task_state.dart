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
/// Loaded state with tasks
class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> tasks; // This is the filtered list used by UI
  final String? filterCompanyId;
  final List<TaskPriority>? filterPriorities;
  final List<TaskVisibility>? filterVisibilities;

  const TaskLoaded({
    required this.allTasks,
    required this.tasks,
    this.filterCompanyId,
    this.filterPriorities,
    this.filterVisibilities,
  });

  @override
  List<Object?> get props => [
    allTasks,
    tasks,
    filterCompanyId,
    filterPriorities,
    filterVisibilities,
  ];
}

/// Error state
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
