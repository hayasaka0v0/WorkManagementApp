import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:equatable/equatable.dart';

class LeaveCompany implements UseCase<void, LeaveCompanyParams> {
  final CompanyRepository repository;

  LeaveCompany(this.repository);

  @override
  Future<Either<Failure, void>> call(LeaveCompanyParams params) async {
    return await repository.leaveCompany(params.userId);
  }
}

class LeaveCompanyParams extends Equatable {
  final String userId;

  const LeaveCompanyParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
