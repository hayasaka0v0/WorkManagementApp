import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/tasks/domain/repositories/task_repository.dart';

/// Use case for deleting a task
class DeleteTask implements UseCase<void, String> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteTask(params);
  }
}
