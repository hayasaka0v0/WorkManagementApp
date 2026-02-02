import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (email.trim().isEmpty) {
        return const Left(ValidationFailure('Email cannot be empty'));
      }
      if (password.trim().isEmpty) {
        return const Left(ValidationFailure('Password cannot be empty'));
      }

      final userModel = await remoteDataSource.login(
        email: email.trim(),
        password: password,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signup({
    required String email,
    required String password,
    String? phoneNumber,
    required String role,
  }) async {
    try {
      // Validate input
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();

      if (trimmedEmail.isEmpty) {
        return const Left(ValidationFailure('Email cannot be empty'));
      }
      if (trimmedPassword.isEmpty) {
        return const Left(ValidationFailure('Password cannot be empty'));
      }
      if (trimmedPassword.length < 6) {
        return const Left(
          ValidationFailure('Password must be at least 6 characters'),
        );
      }

      final userModel = await remoteDataSource.signup(
        email: trimmedEmail,
        password: trimmedPassword,
        phoneNumber: phoneNumber,
        role: role,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel == null) {
        return const Right(null);
      }
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
