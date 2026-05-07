import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../services/supabase_service.dart';

@lazySingleton
class ParentRepository {
  final SupabaseService _supabase;

  ParentRepository(this._supabase);

  Future<List<Profile>> getParents(String organizationId) async {
    final response = await _supabase.client
        .from('user_profiles')
        .select()
        .eq('organization_id', organizationId)
        .eq('role', 'parent');
    
    return (response as List).map((json) => Profile.fromJson(json)).toList();
  }

  Future<List<Profile>> getChildren(String parentId) async {
    // Note: The join syntax depends on the exact relationship name in Supabase.
    // Using the table name 'user_profiles' and filtering by the relationship.
    final response = await _supabase.client
        .from('parent_student_links')
        .select('user_profiles!student_id(*)')
        .eq('parent_id', parentId);
    
    return (response as List).map((json) => Profile.fromJson(json['user_profiles'])).toList();
  }

  Future<void> linkChild(String parentId, String studentId) async {
    await _supabase.client.from('parent_student_links').insert({
      'parent_id': parentId,
      'student_id': studentId,
    });
  }

  Future<void> unlinkChild(String parentId, String studentId) async {
    await _supabase.client
        .from('parent_student_links')
        .delete()
        .eq('parent_id', parentId)
        .eq('student_id', studentId);
  }

  Future<void> deleteParent(String parentId) async {
    // This will trigger cascade delete in parent_student_links if configured
    await _supabase.client.from('user_profiles').delete().eq('id', parentId);
  }
}
