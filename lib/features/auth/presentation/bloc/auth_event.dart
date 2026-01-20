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

  const AuthSignupRequested({
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, phoneNumber];
}

/// Event to logout
class AuthLogoutRequested extends AuthEvent {}
