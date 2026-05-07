import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/profile.dart';

@lazySingleton
class AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepository(this._supabaseService);

  GoTrueClient get _auth => _supabaseService.auth;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  User? get currentUser => _auth.currentUser;

  /// Email Login
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Phone / OTP Login - Send OTP
  Future<void> signInWithPhone(String phone) async {
    try {
      await _auth.signInWithOtp(phone: phone);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Verify OTP
  Future<AuthResponse> verifyOTP(String phone, String token) async {
    try {
      return await _auth.verifyOTP(
        type: OtpType.sms,
        token: token,
        phone: phone,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign Up (Creates auth.users and triggers webhook or requires manual profile insert)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? organizationId,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        phone: phone,
        data: {
          'full_name': fullName,
          'role': role,
          if (organizationId != null) 'organization_id': organizationId,
        },
      );
      
      // The user_profiles table is usually populated via a Supabase Trigger on auth.users insert.
      // If no trigger exists, we would manually insert it here.
      
      return response;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Forgot Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get Current User Profile with Role
  Future<Profile?> getCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final data = await _supabaseService.client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();
      return Profile.fromJson(data);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is AuthException) {
      return Exception(e.message);
    }
    return Exception('An unexpected error occurred: $e');
  }
}
