import 'package:learning/features/auth/domain/entities/user_entity.dart';
import 'package:learning/features/task/domain/entities/task_entity.dart';
/// Task model for data layer - handles JSON serialization
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.companyId,
    required super.creator,
    super.assignee,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
    required super.dueDate,
    super.visibility,
    required super.createdAt,
    required super.updatedAt,
  });
  /// Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      // Parse nested User object (Assuming Supabase join query returns 'creator: {...}')
      creator: UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      assignee: json['assignee'] != null
          ? UserModel.fromJson(json['assignee'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: _stringToStatus(json['status'] as String),
      priority: _stringToPriority(json['priority'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      visibility: _stringToVisibility(json['visibility'] as String? ?? 'team_only'),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  /// Convert TaskModel to JSON (for sending to DB)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'creator_id': creator.id, // We only send IDs to DB
      'assignee_id': assignee?.id,
      'title': title,
      'description': description,
      'status': _statusToString(status),
      'priority': _priorityToString(priority),
      'due_date': dueDate.toIso8601String(),
      'visibility': _visibilityToString(visibility),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  /// Convert TaskModel to Task entity
  Task toEntity() {
    return Task(
      id: id,
      companyId: companyId,
      creator: creator,
      assignee: assignee,
      title: title,
      description: description,
      status: status,
      priority: priority,
      dueDate: dueDate,
      visibility: visibility,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  /// Create TaskModel from Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      companyId: task.companyId,
      creator: task.creator,
      assignee: task.assignee,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      visibility: task.visibility,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
  // --- Helper Methods for Enums ---
  static TaskStatus _stringToStatus(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.pending,
    );
  }
  static String _statusToString(TaskStatus status) => status.name;
  static TaskPriority _stringToPriority(String priority) {
    return TaskPriority.values.firstWhere(
      (e) => e.name == priority,
      orElse: () => TaskPriority.medium,
    );
  }
  static String _priorityToString(TaskPriority priority) => priority.name;
  static TaskVisibility _stringToVisibility(String visibility) {
    // Handle snake_case from DB if necessary (e.g. 'team_only')
    if (visibility == 'team_only') return TaskVisibility.teamOnly;
    return TaskVisibility.values.firstWhere(
      (e) => e.name == visibility,
      orElse: () => TaskVisibility.teamOnly,
    );
  }
  static String _visibilityToString(TaskVisibility visibility) {
    if (visibility == TaskVisibility.teamOnly) return 'team_only';
    return visibility.name;
  }
}
/// Helper UserModel to handle nested User parsing
/// TODO: Move this to auth feature later
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.companyId,
    required super.role,
    super.jobTitle,
    super.avatarUrl,
    required super.createdAt,
    super.phoneNumber,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? 'Unknown',
      companyId: json['company_id'] as String? ?? '',
      role: json['role'] as String? ?? 'employee',
      jobTitle: json['job_title'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      phoneNumber: json['phone_number'] as String?,
    );
  }
}