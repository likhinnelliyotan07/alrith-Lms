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

