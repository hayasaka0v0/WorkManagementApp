import 'package:learning/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract interface for auth remote data source
abstract interface class AuthRemoteDataSource {
  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signup({
    required String email,
    required String password,
    String? phoneNumber,
    required String role,
  });

  Future<void> logout();

  Future<AuthUserModel?> getCurrentUser();
}

/// Implementation of AuthRemoteDataSource using Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: No user returned');
      }

      // Try to fetch user data from users table
      try {
        final userRecord = await client
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

        return AuthUserModel.fromJson(userRecord);
      } catch (e) {
        // If user record doesn't exist, create it (backward compatibility)
        print('⚠️ User record not found, creating one...');

        final userData = {
          'id': response.user!.id,
          'email': response.user!.email!,
          'created_at': response.user!.createdAt,
        };

        final userRecord = await client
            .from('users')
            .insert(userData)
            .select()
            .single();

        print('✅ User record created');
        return AuthUserModel.fromJson(userRecord);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AuthUserModel> signup({
    required String email,
    required String password,
    String? phoneNumber,
    required String role,
  }) async {
    try {
      print('🔵 Attempting signup with email: $email, role: $role');

      // Step 1: Create auth user
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      print('🔵 Signup response received');
      print('🔵 User: ${response.user}');
      print('🔵 Session: ${response.session}');

      if (response.user == null) {
        throw Exception('Signup failed: No user returned');
      }

      print('✅ Auth user created: ${response.user!.email}');

      // Step 2: Upsert user data into users table (handles both new and existing users)
      final userData = {
        'id': response.user!.id,
        'email': response.user!.email!,
        'phone_number': phoneNumber,
        'role': role, // Save user role
        'created_at': response.user!.createdAt,
      };

      print('🔵 Upserting user data into users table: $userData');

      final userRecord = await client
          .from('users')
          .upsert(userData) // Changed from insert to upsert
          .select()
          .single();

      print('✅ User record created/updated in database');

      return AuthUserModel.fromJson(userRecord);
    } on AuthException catch (e) {
      print('❌ AuthException during signup: ${e.message}');
      print('❌ Status code: ${e.statusCode}');
      throw Exception('Signup failed: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error during signup: $e');
      print('❌ Error type: ${e.runtimeType}');
      throw Exception('Failed to signup: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;

      if (user == null) {
        return null;
      }

      // Try to fetch user data from users table
      try {
        final userRecord = await client
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        return AuthUserModel.fromJson(userRecord);
      } catch (e) {
        // If user record doesn't exist, create it (backward compatibility)
        print(
          '⚠️ User record not found during getCurrentUser, creating one...',
        );

        final userData = {
          'id': user.id,
          'email': user.email!,
          'created_at': user.createdAt,
        };

        final userRecord = await client
            .from('users')
            .insert(userData)
            .select()
            .single();

        print('✅ User record created');
        return AuthUserModel.fromJson(userRecord);
      }
    } catch (e) {
      print('❌ Failed to get current user: $e');
      return null;
    }
  }
}
