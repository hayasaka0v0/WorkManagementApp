import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user signup
class Signup implements UseCase<AuthUser, SignupParams> {
  final AuthRepository repository;

  Signup(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignupParams params) async {
    return await repository.signup(
      email: params.email,
      password: params.password,
      phoneNumber: params.phoneNumber,
    );
  }
}

/// Parameters for signup use case
class SignupParams {
  final String email;
  final String password;
  final String? phoneNumber;

  SignupParams({required this.email, required this.password, this.phoneNumber});
}
