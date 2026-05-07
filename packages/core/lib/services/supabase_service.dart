import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@lazySingleton
class SupabaseService {
  Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  SupabaseClient get client => Supabase.instance.client;

  GoTrueClient get auth => client.auth;
  
  SupabaseQueryBuilder from(String table) => client.from(table);

}
