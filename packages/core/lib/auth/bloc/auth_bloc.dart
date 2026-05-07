import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../services/auth_repository.dart';

import '../../models/profile.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final user = _authRepository.currentUser;
      if (user != null) {
        // Fetch profile from database
        try {
          final profile = await _authRepository.getProfile(user.id);
          emit(Authenticated(profile));
        } catch (e) {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (profile) => emit(Authenticated(profile)),
      );
    });


    on<AuthLoggedOut>((event, emit) async {
      await _authRepository.signOut();
      emit(Unauthenticated());
    });

    on<AuthPhoneSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signInWithPhone(event.phone);
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (_) => emit(AuthOTPSent()),
      );
    });

    on<AuthOTPVerifyRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.verifyOTP(event.phone, event.otp);
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (profile) => emit(Authenticated(profile)),
      );
    });

    on<AuthGoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signInWithGoogle();
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (profile) => emit(Authenticated(profile)),
      );
    });

    on<AuthAppleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signInWithApple();
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (profile) => emit(Authenticated(profile)),
      );
    });

    on<AuthPasswordResetRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.resetPassword(event.email);
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (_) => emit(AuthPasswordResetSuccess()),
      );
    });

    on<AuthSignedUp>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.toString())),
        (_) => emit(Unauthenticated()), // Show login after signup
      );
    });
  }
}
