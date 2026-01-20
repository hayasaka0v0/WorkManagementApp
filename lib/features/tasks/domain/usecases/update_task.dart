import 'package:dartz/dartz.dart' hide Task;
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/tasks/domain/entities/task.dart';
import 'package:learning/features/tasks/domain/repositories/task_repository.dart';

/// Use case for updating an existing task
class UpdateTask implements UseCase<Task, Task> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(Task params) async {
    return await repository.updateTask(params);
  }
}
