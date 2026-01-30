import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
import 'package:learning/features/task/domain/repositories/task_repository.dart';

/// Use case for creating a new task
class CreateTask implements UseCase<Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CreateTaskParams params) async {
    return await repository.createTask(
      title: params.title,
      description: params.description,
      companyId: params.companyId,
      dueDate: params.dueDate,
      priority: params.priority,
      assigneeId: params.assigneeId,
    );
  }
}

/// Parameters for creating a task
class CreateTaskParams extends Equatable {
  final String title;
  final String description;
  final String companyId;
  final DateTime dueDate;
  final TaskPriority priority;
  final String? assigneeId;

  const CreateTaskParams({
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
