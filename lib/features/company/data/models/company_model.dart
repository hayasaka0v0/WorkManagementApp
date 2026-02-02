import 'package:learning/features/company/domain/entities/company.dart';

/// Model for Company with JSON serialization
class CompanyModel extends Company {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.inviteCode,
    required super.ownerId,
    required super.createdAt,
  });

  /// Create CompanyModel from JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['company_name'] as String, // DB column is company_name
      inviteCode: json['invite_code'] as String,
      ownerId: json['owner_id'] as String? ?? '', // owner_id may be null
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': name, // DB column is company_name
      'invite_code': inviteCode,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert to Entity
  Company toEntity() {
    return Company(
      id: id,
      name: name,
      inviteCode: inviteCode,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }

  /// Create from Entity
  factory CompanyModel.fromEntity(Company company) {
    return CompanyModel(
      id: company.id,
      name: company.name,
      inviteCode: company.inviteCode,
      ownerId: company.ownerId,
      createdAt: company.createdAt,
    );
  }
}
