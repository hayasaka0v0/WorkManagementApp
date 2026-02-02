import 'package:dartz/dartz.dart' hide Task;
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();

  Future<Either<Failure, Task>> getTaskById(String taskId);

  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
    String? companyId,
    required DateTime dueDate,
    required TaskPriority priority,
    required TaskStatus status,
    required TaskVisibility visibility,
    String? assigneeId,
  });

  Future<Either<Failure, Task>> updateTask(Task task);

  Future<Either<Failure, void>> deleteTask(String taskId);
}
