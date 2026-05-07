import 'dart:developer';

import 'package:core/models/schedule.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/profile.dart';
import '../models/course.dart';
import '../models/batch.dart';
import '../services/supabase_service.dart';

@lazySingleton
class AdminRepository {
  final SupabaseService _supabase;

  AdminRepository(this._supabase);

  String? get currentOrgId => _supabase.currentOrganizationId;

  // Statistics
  Future<Map<String, dynamic>> getDashboardStats([
    String? organizationId,
  ]) async {
    final orgId = organizationId ?? currentOrgId;
    if (orgId == null) return {};

    final studentRes = await _supabase.client
        .from('user_profiles')
        .select('id')
        .eq('organization_id', orgId)
        .eq('role', 'student')
        .count(CountOption.exact);

    final teacherRes = await _supabase.client
        .from('user_profiles')
        .select('id')
        .eq('organization_id', orgId)
        .eq('role', 'teacher')
        .count(CountOption.exact);

    final courseRes = await _supabase.client
        .from('courses')
        .select('id')
        .eq('organization_id', orgId)
        .count(CountOption.exact);

    final enrollmentRes = await _supabase.client
        .from('enrollments')
        .select('id')
        .eq('status', 'active')
        .count(CountOption.exact);

    return {
      'totalStudents': studentRes.count ?? 0,
      'totalTeachers': teacherRes.count ?? 0,
      'activeCourses': courseRes.count ?? 0,
      'activeEnrollments': enrollmentRes.count ?? 0,
      'liveClassStats': '85% Attendance',
      'revenue': 125000.0,
    };
  }

  // Organization Management
  Future<void> createOrganization(String name) async {
    final user = _supabase.client.auth.currentUser;
    if (user == null)
      throw Exception('Must be logged in to create organization');

    final response = await _supabase.client
        .from('organizations')
        .insert({'name': name, 'slug': name.toLowerCase().replaceAll(' ', '-')})
        .select()
        .single();

    final orgId = response['id'];

    // Update user's profile with this organization
    await _supabase.client
        .from('user_profiles')
        .update({'organization_id': orgId})
        .eq('id', user.id);

    // Also update metadata for instant session access
    await _supabase.client.auth.updateUser(
      UserAttributes(data: {'organization_id': orgId}),
    );
  }

  // Teacher Management
  Future<List<Profile>> getTeachers([String? organizationId]) async {
    final orgId = organizationId ?? currentOrgId;
    if (orgId == null) return [];

    final response = await _supabase.client
        .from('user_profiles')
        .select()
        .eq('organization_id', orgId)
        .eq('role', 'teacher');

    return (response as List).map((json) => Profile.fromJson(json)).toList();
  }

  Future<void> createTeacher({
    required String name,
    required String email,
    required String password,
  }) async {
    final orgId = currentOrgId;
    if (orgId == null) throw Exception('No active organization');

    final response = await _supabase.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    if (response.user != null) {
      await _supabase.client.from('user_profiles').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': name,
        'role': 'teacher',
        'organization_id': orgId,
      });
    }
  }

  // Student Management
  Future<List<Profile>> getStudents([String? organizationId]) async {
    final orgId = organizationId ?? currentOrgId;
    if (orgId == null) return [];

    final response = await _supabase.client
        .from('user_profiles')
        .select()
        .eq('organization_id', orgId)
        .eq('role', 'student');

    return (response as List).map((json) => Profile.fromJson(json)).toList();
  }

  Future<void> createStudent({
    required String name,
    required String email,
    required String password,
  }) async {
    final orgId = currentOrgId;
    if (orgId == null) throw Exception('No active organization');

    final response = await _supabase.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    if (response.user != null) {
      await _supabase.client.from('user_profiles').insert({
        'id': response.user!.id,
        'email': email,
        'full_name': name,
        'role': 'student',
        'organization_id': orgId,
      });
    }
  }

  // Session Management
  Future<String?> syncOrganizationId() async {
    final user = _supabase.client.auth.currentUser;
    if (user == null) return null;

    // 1. Try metadata first (fastest)
    String? orgId = user.userMetadata?['organization_id'];

    if (orgId == null) {
      // 2. Check user_profiles table
      final profile = await _supabase.client
          .from('user_profiles')
          .select('organization_id')
          .eq('id', user.id)
          .maybeSingle();

      orgId = profile?['organization_id'];

      if (orgId != null) {
        // 3. Update metadata for future sessions
        await _supabase.client.auth.updateUser(
          UserAttributes(data: {'organization_id': orgId}),
        );
      }
    }

    return orgId;
  }

  // Live Class Management
  Future<void> createLiveClass({
    required String title,
    required String batchId,
    required DateTime startTime,
    required DateTime endTime,
    String? meetingUrl,
  }) async {
    final orgId = currentOrgId;
    if (orgId == null) throw Exception('No active organization');

    await _supabase.client.from('live_classes').insert({
      'title': title,
      'batch_id': batchId,
      'organization_id': orgId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'meeting_url': meetingUrl,
      'status': 'scheduled',
    });
  }

  Future<List<Map<String, dynamic>>> getLiveClasses() async {
    final orgId = currentOrgId;
    if (orgId == null) return [];

    return await _supabase.client
        .from('live_classes')
        .select('*, batches(name)')
        .eq('organization_id', orgId)
        .order('start_time');
  }

  // Course Management
  Future<void> createCourse(Course course) async {
    final orgId = currentOrgId;
    if (orgId == null) throw Exception('No active organization');

    final courseJson = course.toJson();
    courseJson['organization_id'] = orgId;
    if (courseJson['id'] == '') {
      courseJson.remove('id');
    }

    await _supabase.client.from('courses').insert(courseJson);
  }

  Future<List<Course>> getCourses([String? organizationId]) async {
    final orgId = organizationId ?? currentOrgId;
    if (orgId == null) return [];

    final response = await _supabase.client
        .from('courses')
        .select()
        .eq('organization_id', orgId);

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

  // Batch Management
  Future<List<Batch>> getBatches([String? organizationId]) async {
    final orgId = organizationId ?? currentOrgId;
    if (orgId == null) return [];

    final response = await _supabase.client
        .from('batches')
        .select('*, schedules(*)')
        .eq('organization_id', orgId);

    return (response as List).map((json) => Batch.fromJson(json)).toList();
  }

  Future<void> createBatch(Batch batch) async {
    final orgId = currentOrgId;
    if (orgId == null) throw Exception('No active organization');

    final batchJson = batch.toJson();
    batchJson['organization_id'] = orgId;
    batchJson.remove('id');
    print("batch `$batchJson");

    //batchJson['id'] =  Uuid().v4();

    await _supabase.client.from('batches').insert(batchJson);
  }

  // Audit Logs
  Future<List<Map<String, dynamic>>> getAuditLogs(String organizationId) async {
    final response = await _supabase.client
        .from('audit_logs')
        .select('*, user_profiles(full_name)')
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
