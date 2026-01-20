import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-side failure (API errors, database errors, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache failure (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network failure (no internet connection, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failure (invalid input data)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
