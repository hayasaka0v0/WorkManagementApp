import 'package:equatable/equatable.dart';
import 'package:learning/features/auth/domain/entities/user_entity.dart';

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { low, medium, high, urgent }

enum TaskVisibility { public, private, teamOnly }

/// Task entity - represents a task in the domain layer
class Task extends Equatable {
  final String id;
  final String? companyId;
  // Make companyName nullable as it might not be populated in all contexts (e.g. creation before fetch)
  final String? companyName;
  final User creator;
  final User? assignee;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime dueDate;
  final TaskVisibility visibility;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    this.companyId,
    this.companyName,
    required this.creator,
    this.assignee,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    this.visibility = TaskVisibility.teamOnly,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this task with some fields updated
  Task copyWith({
    String? id,
    String? companyId,
    String? companyName,
    User? creator,
    User? assignee,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    TaskVisibility? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      creator: creator ?? this.creator,
      assignee: assignee ?? this.assignee,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      visibility: visibility ?? this.visibility,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    companyId,
    companyName,
    creator,
    assignee,
    title,
    description,
    status,
    priority,
    dueDate,
    visibility,
    createdAt,
    updatedAt,
  ];
}
