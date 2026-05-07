part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Profile profile;

  const Authenticated({required this.profile});

  @override
  List<Object> get props => [profile];
}

class Unauthenticated extends AuthState {}

class AuthOtpSent extends AuthState {
  final String phone;

  const AuthOtpSent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class AuthProfileIncomplete extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
