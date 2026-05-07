import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification.dart';
import '../services/supabase_service.dart';

@lazySingleton
class CommunicationRepository {
  final SupabaseService _supabase;

  CommunicationRepository(this._supabase);

  Future<List<AppNotification>> getNotifications(String userId) async {
    final response = await _supabase.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => AppNotification.fromJson(json)).toList();
  }

  Future<void> sendAnnouncement({
    required String organizationId,
    required String title,
    required String message,
    String? role, // Optional target role
  }) async {
    // 1. Get target users
    var query = _supabase.client.from('user_profiles').select('id').eq('organization_id', organizationId);
    if (role != null) {
      query = query.eq('role', role);
    }
    
    final users = await query;
    final List<Map<String, dynamic>> notifications = (users as List).map((user) => {
      'user_id': user['id'],
      'title': title,
      'message': message,
      'type': 'announcement',
    }).toList();

    // 2. Batch insert notifications
    if (notifications.isNotEmpty) {
      await _supabase.client.from('notifications').insert(notifications);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabase.client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}
