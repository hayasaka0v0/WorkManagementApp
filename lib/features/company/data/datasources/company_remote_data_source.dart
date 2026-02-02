import 'dart:math';
import 'package:learning/features/company/data/models/company_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract interface for company remote data source
abstract interface class CompanyRemoteDataSource {
  /// Create a new company with auto-generated invite code
  Future<CompanyModel> createCompany({
    required String name,
    required String ownerId,
  });

  /// Join company by invite code and update user's company_id
  Future<CompanyModel> joinCompany({
    required String inviteCode,
    required String userId,
  });

  /// Get company by ID
  Future<CompanyModel> getCompanyById(String id);

  /// Get company by invite code
  Future<CompanyModel> getCompanyByInviteCode(String inviteCode);

  /// Regenerate invite code for a company
  Future<CompanyModel> regenerateInviteCode(String companyId);

  /// Leave current company
  Future<void> leaveCompany(String userId);
}

/// Implementation of CompanyRemoteDataSource using Supabase
class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final SupabaseClient client;

  CompanyRemoteDataSourceImpl(this.client);

  static const String _tableName = 'companies';
  static const String _usersTable = 'users';

  /// Generate a random 8-character invite code
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<CompanyModel> createCompany({
    required String name,
    required String ownerId,
  }) async {
    try {
      final inviteCode = _generateInviteCode();

      // Create company record - use company_name as per DB schema
      final companyData = {
        'company_name': name,
        'invite_code': inviteCode,
        // Note: created_at has default value in DB, no need to set
      };

      final response = await client
          .from(_tableName)
          .insert(companyData)
          .select()
          .single();

      final company = CompanyModel.fromJson(response);

      // Update owner's company_id
      await client
          .from(_usersTable)
          .update({'company_id': company.id})
          .eq('id', ownerId);

      print(
        '✅ Company created: ${company.name} with code: ${company.inviteCode}',
      );

      return company;
    } catch (e) {
      print('❌ Failed to create company: $e');
      throw Exception('Failed to create company: $e');
    }
  }

  @override
  Future<CompanyModel> joinCompany({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      // Find company by invite code
      final response = await client
          .from(_tableName)
          .select()
          .eq('invite_code', inviteCode)
          .single();

      final company = CompanyModel.fromJson(response);

      // Update user's company_id
      await client
          .from(_usersTable)
          .update({'company_id': company.id})
          .eq('id', userId);

      print('✅ User $userId joined company: ${company.name}');

      return company;
    } catch (e) {
      print('❌ Failed to join company: $e');
      throw Exception(
        'Failed to join company. Invalid invite code or company not found.',
      );
    }
  }

  @override
  Future<CompanyModel> getCompanyById(String id) async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return CompanyModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get company: $e');
    }
  }

  @override
  Future<CompanyModel> getCompanyByInviteCode(String inviteCode) async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .eq('invite_code', inviteCode)
          .single();

      return CompanyModel.fromJson(response);
    } catch (e) {
      throw Exception('Company not found with invite code: $inviteCode');
    }
  }

  @override
  Future<CompanyModel> regenerateInviteCode(String companyId) async {
    try {
      final newInviteCode = _generateInviteCode();

      final response = await client
          .from(_tableName)
          .update({'invite_code': newInviteCode})
          .eq('id', companyId)
          .select()
          .single();

      final company = CompanyModel.fromJson(response);
      print(
        '✅ Invite code regenerated for ${company.name}: ${company.inviteCode}',
      );
      return company;
    } catch (e) {
      print('❌ Failed to regenerate invite code: $e');
      throw Exception('Failed to regenerate invite code: $e');
    }
  }

  @override
  Future<void> leaveCompany(String userId) async {
    try {
      await client
          .from(_usersTable)
          .update({'company_id': null})
          .eq('id', userId);

      print('✅ User $userId left company');
    } catch (e) {
      print('❌ Failed to leave company: $e');
      throw Exception('Failed to leave company: $e');
    }
  }
}
