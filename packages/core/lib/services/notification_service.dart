import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  Future<void> sendPushNotification(String userId, String title, String body) async {
    // Logic for Firebase Cloud Messaging or Supabase Edge Functions
  }

  Future<void> sendEmail(String email, String subject, String body) async {
    // Logic for SendGrid/Resend via Supabase Edge Functions
  }
}
