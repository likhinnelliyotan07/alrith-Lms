import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@lazySingleton
class SupabaseService {
  Future<void> initialize() async {
    final url = dotenv.maybeGet('SUPABASE_URL');
    final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY');
    
    if (url == null || anonKey == null) {
      throw Exception('Supabase configuration missing in .env file. Expected SUPABASE_URL and SUPABASE_ANON_KEY.');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;
  
  String? get currentOrganizationId {
    final user = client.auth.currentUser;
    return user?.userMetadata?['organization_id'] as String?;
  }

  GoTrueClient get auth => client.auth;
  
  SupabaseQueryBuilder from(String table) => client.from(table);

  // Storage Helpers
  SupabaseStorageClient get storage => client.storage;
  
  String getPublicUrl(String bucket, String path) {
    return storage.from(bucket).getPublicUrl(path);
  }

  // Realtime Helpers
  Stream<List<Map<String, dynamic>>> subscribeToTable(String table) {
    return client.from(table).stream(primaryKey: ['id']);
  }
}

