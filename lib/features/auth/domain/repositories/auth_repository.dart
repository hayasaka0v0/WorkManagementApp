import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';

/// Repository interface for authentication operations
abstract interface class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  });

  /// Register a new user with email and password
  Future<Either<Failure, AuthUser>> signup({
    required String email,
    required String password,
    String? phoneNumber,
    required String role,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> logout();

  /// Get the currently authenticated user
  Future<Either<Failure, AuthUser?>> getCurrentUser();
}
