import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/company/domain/entities/company.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

/// Use case for joining an existing company
class JoinCompany implements UseCase<Company, JoinCompanyParams> {
  final CompanyRepository repository;

  JoinCompany(this.repository);

  @override
  Future<Either<Failure, Company>> call(JoinCompanyParams params) async {
    return await repository.joinCompany(
      inviteCode: params.inviteCode,
      userId: params.userId,
    );
  }
}

/// Parameters for join company use case
class JoinCompanyParams {
  final String inviteCode;
  final String userId;

  JoinCompanyParams({required this.inviteCode, required this.userId});
}
