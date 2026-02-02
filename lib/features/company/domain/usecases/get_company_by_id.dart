import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/company/domain/entities/company.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

class GetCompanyById implements UseCase<Company, GetCompanyByIdParams> {
  final CompanyRepository repository;

  GetCompanyById(this.repository);

  @override
  Future<Either<Failure, Company>> call(GetCompanyByIdParams params) async {
    return await repository.getCompanyById(params.companyId);
  }
}

class GetCompanyByIdParams extends Equatable {
  final String companyId;

  const GetCompanyByIdParams({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}
