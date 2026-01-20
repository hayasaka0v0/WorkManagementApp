import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
class Login implements UseCase<AuthUser, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
