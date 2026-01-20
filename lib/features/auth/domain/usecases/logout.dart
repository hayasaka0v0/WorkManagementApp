import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
