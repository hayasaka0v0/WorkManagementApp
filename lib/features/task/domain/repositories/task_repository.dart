import 'package:dartz/dartz.dart' hide Task;
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/task/domain/entities/task.dart';

/// Repository interface for task operations
/// This defines the contract that the data layer must implement
abstract interface class TaskRepository {
  /// Get all tasks for the current user
  Future<Either<Failure, List<Task>>> getTasks();

  /// Get a specific task by ID
  Future<Either<Failure, Task>> getTaskById(String id);

  /// Create a new task
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  });

  /// Update an existing task
  Future<Either<Failure, Task>> updateTask(Task task);

  /// Delete a task by ID
  Future<Either<Failure, void>> deleteTask(String id);
}
