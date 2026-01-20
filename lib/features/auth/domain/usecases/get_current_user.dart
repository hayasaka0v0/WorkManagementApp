import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting the current authenticated user
class GetCurrentUser implements UseCase<AuthUser?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
