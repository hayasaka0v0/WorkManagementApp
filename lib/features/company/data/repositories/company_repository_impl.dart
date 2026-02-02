import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/company/data/datasources/company_remote_data_source.dart';
import 'package:learning/features/company/domain/entities/company.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

/// Implementation of CompanyRepository
class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Company>> createCompany({
    required String name,
    required String ownerId,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return const Left(ValidationFailure('Company name cannot be empty'));
      }

      final companyModel = await remoteDataSource.createCompany(
        name: name.trim(),
        ownerId: ownerId,
      );
      return Right(companyModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> joinCompany({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      if (inviteCode.trim().isEmpty) {
        return const Left(ValidationFailure('Invite code cannot be empty'));
      }

      final companyModel = await remoteDataSource.joinCompany(
        inviteCode: inviteCode.trim().toUpperCase(),
        userId: userId,
      );
      return Right(companyModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompanyById(String id) async {
    try {
      final companyModel = await remoteDataSource.getCompanyById(id);
      return Right(companyModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompanyByInviteCode(
    String inviteCode,
  ) async {
    try {
      final companyModel = await remoteDataSource.getCompanyByInviteCode(
        inviteCode,
      );
      return Right(companyModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> regenerateInviteCode(
    String companyId,
  ) async {
    try {
      final companyModel = await remoteDataSource.regenerateInviteCode(
        companyId,
      );
      return Right(companyModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCompany(String userId) async {
    try {
      await remoteDataSource.leaveCompany(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AuthUser>>> getCompanyMembers(
    String companyId,
  ) async {
    try {
      final models = await remoteDataSource.getCompanyMembers(companyId);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
