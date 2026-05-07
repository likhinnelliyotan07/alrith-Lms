import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../models/profile.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginWithEmail>(_onLoginWithEmail);
    on<LoginWithPhone>(_onLoginWithPhone);
    on<VerifyOTP>(_onVerifyOTP);
    on<SignOutRequested>(_onSignOutRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LoginWithApple>(_onLoginWithApple);
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit) async {
    // Add Google Login Repo call
    emit(AuthLoading());
    try {
      // await _authRepository.signInWithGoogle(); 
      // add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginWithApple(LoginWithApple event, Emitter<AuthState> emit) async {
    // Add Apple Login Repo call
    emit(AuthLoading());
    try {
      // await _authRepository.signInWithApple(); 
      // add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        final profile = await _authRepository.getCurrentProfile();
        if (profile != null) {
          emit(Authenticated(profile: profile));
        } else {
          // User authenticated but no profile found (maybe incomplete signup)
          emit(AuthProfileIncomplete());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginWithEmail(LoginWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmail(event.email, event.password);
      add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginWithPhone(LoginWithPhone event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithPhone(event.phone);
      emit(AuthOtpSent(phone: event.phone));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyOTP(VerifyOTP event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyOTP(event.phone, event.otp);
      add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        role: event.role,
        phone: event.phone,
        organizationId: event.organizationId,
      );
      add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
