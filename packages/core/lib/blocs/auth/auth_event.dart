part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginWithEmail extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmail({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithPhone extends AuthEvent {
  final String phone;

  const LoginWithPhone({required this.phone});

  @override
  List<Object> get props => [phone];
}

class VerifyOTP extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOTP({required this.phone, required this.otp});

  @override
  List<Object> get props => [phone, otp];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;
  final String? phone;
  final String? organizationId;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    this.phone,
    this.organizationId,
  });

  @override
  List<Object?> get props => [email, password, fullName, role, phone, organizationId];
}

class SignOutRequested extends AuthEvent {}

class LoginWithGoogle extends AuthEvent {}

class LoginWithApple extends AuthEvent {}
