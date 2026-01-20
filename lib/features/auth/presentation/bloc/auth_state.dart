part of 'auth_bloc.dart';

/// Base class for all auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state
class AuthLoading extends AuthState {}

/// Authenticated state with user
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
