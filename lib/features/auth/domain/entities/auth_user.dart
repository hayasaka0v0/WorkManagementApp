import 'package:equatable/equatable.dart';

/// Entity representing an authenticated user
class AuthUser extends Equatable {
  final String id;
  final String email;
  final DateTime createdAt;
  final String? phoneNumber;
  final String? fullName;
  final String? companyId;
  final String? role;
  final String? jobTitle;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.createdAt,
    this.phoneNumber,
    this.fullName,
    this.companyId,
    this.role,
    this.jobTitle,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    createdAt,
    phoneNumber,
    fullName,
    companyId,
    role,
    jobTitle,
    avatarUrl,
  ];
}
