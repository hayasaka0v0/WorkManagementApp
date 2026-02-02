part of 'auth_bloc.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {}

/// Event to login with email and password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to signup with email and password
class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String? phoneNumber;
  final String role; // boss, manager, employee

  const AuthSignupRequested({
    required this.email,
    required this.password,
    this.phoneNumber,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, phoneNumber, role];
}

/// Event to logout
class AuthLogoutRequested extends AuthEvent {}

/// Event to leave company
class AuthLeaveCompanyRequested extends AuthEvent {
  final String userId;

  const AuthLeaveCompanyRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
