import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/tasks/domain/entities/task.dart';
import 'package:learning/features/tasks/domain/repositories/task_repository.dart';

/// Use case for creating a new task
class CreateTask implements UseCase<Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CreateTaskParams params) async {
    return await repository.createTask(
      title: params.title,
      description: params.description,
    );
  }
}

/// Parameters for creating a task
class CreateTaskParams extends Equatable {
  final String title;
  final String description;

  const CreateTaskParams({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
