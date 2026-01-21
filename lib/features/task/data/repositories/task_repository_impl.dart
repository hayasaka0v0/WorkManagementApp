import 'package:dartz/dartz.dart' hide Task;
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/task/data/datasources/task_remote_data_source.dart';
import 'package:learning/features/task/data/models/task_model.dart';
import 'package:learning/features/task/domain/entities/task.dart';
import 'package:learning/features/task/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskModels = await remoteDataSource.getTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      final taskModel = await remoteDataSource.getTaskById(id);
      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      // Validate input
      if (title.trim().isEmpty) {
        return const Left(ValidationFailure('Title cannot be empty'));
      }

      final taskModel = await remoteDataSource.createTask(
        title: title.trim(),
        description: description.trim(),
      );
      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      // Validate input
      if (task.title.trim().isEmpty) {
        return const Left(ValidationFailure('Title cannot be empty'));
      }

      final taskModel = TaskModel.fromEntity(task);
      final updatedModel = await remoteDataSource.updateTask(taskModel);
      return Right(updatedModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
