import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/company/domain/entities/company.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

class RegenerateInviteCode
    implements UseCase<Company, RegenerateInviteCodeParams> {
  final CompanyRepository repository;

  RegenerateInviteCode(this.repository);

  @override
  Future<Either<Failure, Company>> call(
    RegenerateInviteCodeParams params,
  ) async {
    return await repository.regenerateInviteCode(params.companyId);
  }
}

class RegenerateInviteCodeParams extends Equatable {
  final String companyId;

  const RegenerateInviteCodeParams({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}
