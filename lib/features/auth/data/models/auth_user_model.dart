import 'package:learning/features/auth/domain/entities/auth_user.dart';

/// Model for AuthUser with JSON serialization
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.createdAt,
    super.phoneNumber,
    super.fullName,
    super.companyId,
    super.role,
    super.jobTitle,
    super.avatarUrl,
  });

  /// Create AuthUserModel from JSON
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      phoneNumber: json['phone_number'] as String?,
      fullName: json['full_name'] as String?,
      companyId: json['company_id'] as String?,
      role: json['role'] as String?,
      jobTitle: json['job_title'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Convert AuthUserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'phone_number': phoneNumber,
      'full_name': fullName,
      'company_id': companyId,
      'role': role,
      'job_title': jobTitle,
      'avatar_url': avatarUrl,
    };
  }

  /// Convert model to entity
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
      fullName: fullName,
      companyId: companyId,
      role: role,
      jobTitle: jobTitle,
      avatarUrl: avatarUrl,
    );
  }

  /// Create model from entity
  factory AuthUserModel.fromEntity(AuthUser user) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      createdAt: user.createdAt,
      phoneNumber: user.phoneNumber,
      fullName: user.fullName,
      companyId: user.companyId,
      role: user.role,
      jobTitle: user.jobTitle,
      avatarUrl: user.avatarUrl,
    );
  }
}
