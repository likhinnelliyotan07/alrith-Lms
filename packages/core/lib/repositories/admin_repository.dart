import 'package:core/models/schedule.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../models/course.dart';
import '../models/batch.dart';
import '../services/supabase_service.dart';

@lazySingleton
class AdminRepository {
  final SupabaseService _supabase;

  AdminRepository(this._supabase);

  // Statistics
  Future<Map<String, dynamic>> getDashboardStats(String organizationId) async {
    final studentCount = await _supabase.client
        .from('user_profiles')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('role', 'student')
        .count(CountOption.exact);

    final teacherCount = await _supabase.client
        .from('user_profiles')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('role', 'teacher')
        .count(CountOption.exact);

    final courseCount = await _supabase.client
        .from('courses')
        .select('id')
        .eq('organization_id', organizationId)
        .count(CountOption.exact);

    return {
      'totalStudents': studentCount,
      'totalTeachers': teacherCount,
      'activeCourses': courseCount,
      'revenue': 125000.0,
    };
  }


  // Student Management
  Future<List<Profile>> getStudents(String organizationId) async {
    final response = await _supabase.client
        .from('user_profiles')
        .select()
        .eq('organization_id', organizationId)
        .eq('role', 'student');
    
    return (response as List).map((json) => Profile.fromJson(json)).toList();
  }

  // Teacher Management
  Future<List<Profile>> getTeachers(String organizationId) async {
    final response = await _supabase.client
        .from('user_profiles')
        .select()
        .eq('organization_id', organizationId)
        .eq('role', 'teacher');
    
    return (response as List).map((json) => Profile.fromJson(json)).toList();
  }


  // Course Management
  Future<List<Course>> getCourses(String organizationId) async {
    final response = await _supabase.client
        .from('courses')
        .select()
        .eq('organization_id', organizationId);
    
    return (response as List).map((json) => Course.fromJson(json)).toList();
  }

  Future<Course> getCourseById(String courseId) async {
    final response = await _supabase.client
        .from('courses')
        .select('*, subjects(*, modules(*, contents(*)))')
        .eq('id', courseId)
        .single();
    
    return Course.fromJson(response);
  }

  Future<void> createCourse(Course course) async {
    await _supabase.client.from('courses').insert(course.toJson());
  }

  // Profile CRUD
  Future<void> createProfile(Profile profile) async {
    await _supabase.client.from('user_profiles').insert(profile.toJson());
  }

  Future<void> updateProfile(Profile profile) async {
    await _supabase.client.from('user_profiles').update(profile.toJson()).eq('id', profile.id);
  }

  Future<void> deleteProfile(String profileId) async {
    await _supabase.client.from('user_profiles').delete().eq('id', profileId);
  }

  // Batch Management
  Future<List<Batch>> getBatches(String organizationId) async {
    final response = await _supabase.client
        .from('batches')
        .select('*, schedules(*)')
        .eq('organization_id', organizationId);
    
    return (response as List).map((json) => Batch.fromJson(json)).toList();
  }

  Future<void> createBatch(Batch batch) async {
    await _supabase.client.from('batches').insert(batch.toJson());
  }

  Future<void> updateBatchSchedule(String batchId, List<Schedule> schedules) async {
    await _supabase.client.from('schedules').delete().eq('batch_id', batchId);
    await _supabase.client.from('schedules').insert(schedules.map((s) => s.toJson()).toList());
  }
}
