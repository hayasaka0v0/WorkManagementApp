import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

class GetCompanyMembers
    implements UseCase<List<AuthUser>, GetCompanyMembersParams> {
  final CompanyRepository repository;

  GetCompanyMembers(this.repository);

  @override
  Future<Either<Failure, List<AuthUser>>> call(
    GetCompanyMembersParams params,
  ) async {
    return await repository.getCompanyMembers(params.companyId);
  }
}

class GetCompanyMembersParams {
  final String companyId;

  GetCompanyMembersParams({required this.companyId});
}
