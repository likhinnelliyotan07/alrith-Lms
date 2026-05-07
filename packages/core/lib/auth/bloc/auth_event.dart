import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthLoggedOut extends AuthEvent {}

class AuthPhoneSignInRequested extends AuthEvent {
  final String phone;
  const AuthPhoneSignInRequested(this.phone);
  @override
  List<Object?> get props => [phone];
}

class AuthOTPVerifyRequested extends AuthEvent {
  final String phone;
  final String otp;
  const AuthOTPVerifyRequested(this.phone, this.otp);
  @override
  List<Object?> get props => [phone, otp];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthAppleSignInRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthPasswordResetRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthSignedUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignedUp({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
