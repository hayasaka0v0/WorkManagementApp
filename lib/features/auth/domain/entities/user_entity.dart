import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String companyId;
  final String role;
  final String? jobTitle;
  final String? avatarUrl;
  final DateTime createdAt;
  final String? phoneNumber;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.companyId,
    required this.role,
    this.jobTitle,
    this.avatarUrl,
    required this.createdAt,
    this.phoneNumber,
  });

  /// Tạo bản sao của User với các trường được cập nhật
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? companyId,
    String? role,
    String? jobTitle,
    String? avatarUrl,
    DateTime? createdAt,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
      jobTitle: jobTitle ?? this.jobTitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    companyId,
    role,
    jobTitle,
    avatarUrl,
    createdAt,
    phoneNumber,
  ];
}
