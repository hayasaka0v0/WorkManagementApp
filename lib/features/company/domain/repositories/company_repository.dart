import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/company/domain/entities/company.dart';

/// Repository interface for company operations
abstract interface class CompanyRepository {
  /// Create a new company
  /// Returns the created Company with generated invite code
  Future<Either<Failure, Company>> createCompany({
    required String name,
    required String ownerId,
  });

  /// Join an existing company using invite code
  /// Returns the joined Company
  Future<Either<Failure, Company>> joinCompany({
    required String inviteCode,
    required String userId,
  });

  /// Get company by ID
  Future<Either<Failure, Company>> getCompanyById(String id);

  /// Get company by invite code
  Future<Either<Failure, Company>> getCompanyByInviteCode(String inviteCode);

  /// Regenerate invite code for a company
  Future<Either<Failure, Company>> regenerateInviteCode(String companyId);

  /// Leave current company
  Future<Either<Failure, void>> leaveCompany(String userId);
}
