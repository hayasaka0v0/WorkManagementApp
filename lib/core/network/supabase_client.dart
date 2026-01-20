import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton class to manage Supabase client initialization
class SupabaseClientManager {
  static SupabaseClient? _instance;

  /// Initialize Supabase with credentials from .env file
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
        'Supabase credentials not found. Please create a .env file with SUPABASE_URL and SUPABASE_ANON_KEY',
      );
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

    _instance = Supabase.instance.client;
  }

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_instance == null) {
      throw Exception(
        'Supabase client not initialized. Call SupabaseClientManager.initialize() first.',
      );
    }
    return _instance!;
  }
}
