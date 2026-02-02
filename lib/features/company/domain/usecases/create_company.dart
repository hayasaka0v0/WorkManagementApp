import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/company/domain/entities/company.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';

/// Use case for creating a new company
class CreateCompany implements UseCase<Company, CreateCompanyParams> {
  final CompanyRepository repository;

  CreateCompany(this.repository);

  @override
  Future<Either<Failure, Company>> call(CreateCompanyParams params) async {
    return await repository.createCompany(
      name: params.name,
      ownerId: params.ownerId,
    );
  }
}

/// Parameters for create company use case
class CreateCompanyParams {
  final String name;
  final String ownerId;

  CreateCompanyParams({required this.name, required this.ownerId});
}
