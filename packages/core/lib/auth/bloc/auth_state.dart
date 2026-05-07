import 'package:equatable/equatable.dart';
import '../../models/profile.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Profile profile;

  const Authenticated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthOTPSent extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}
