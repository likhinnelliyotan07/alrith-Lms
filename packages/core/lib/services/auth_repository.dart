import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import '../models/profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, Profile>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signInWithPhone(String phone);

  Future<Either<Failure, Profile>> verifyOTP(String phone, String otp);

  Future<Either<Failure, Profile>> signInWithGoogle();

  Future<Either<Failure, Profile>> signInWithApple();

  Future<Either<Failure, Unit>> resetPassword(String email);

  Future<void> signOut();

  Future<Profile> getProfile(String userId);

  supabase.User? get currentUser;

  Stream<supabase.AuthState> get authStateChanges;
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  supabase.User? get currentUser => _client.auth.currentUser;

  @override
  Future<Either<Failure, Profile>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final profile = await getProfile(response.user!.id);
        return Right(profile);
      }
      return const Left(ServerFailure('Login failed'));
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Profile> getProfile(String userId) async {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
        .single();
    return Profile.fromJson(response);
  }

  @override
  Future<Either<Failure, Unit>> signInWithPhone(String phone) async {
    try {
      await _client.auth.signInWithOtp(phone: phone);
      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> verifyOTP(String phone, String otp) async {
    try {
      final response = await _client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: supabase.OtpType.sms,
      );
      if (response.user != null) {
        final profile = await getProfile(response.user!.id);
        return Right(profile);
      }
      return const Left(ServerFailure('OTP verification failed'));
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(supabase.OAuthProvider.google);
      // OAuth flow handles redirection, usually profile is fetched after return
      // This is a simplified version
      return const Left(ServerFailure('OAuth flow redirected'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> signInWithApple() async {
    try {
      await _client.auth.signInWithOAuth(supabase.OAuthProvider.apple);
      return const Left(ServerFailure('OAuth flow redirected'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Stream<supabase.AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}

