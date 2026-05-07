import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Stream<AuthState> get authStateChanges;
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return Right(response.user!);
      }
      return const Left(ServerFailure('Login failed'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() => _supabase.auth.signOut();

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
