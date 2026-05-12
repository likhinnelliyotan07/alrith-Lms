import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../widgets/admin_login_view.dart';
import '../widgets/premium_signup_view.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

class AppRouter {

  final AuthBloc _authBloc;
  final List<RouteBase> _extraRoutes;

  AppRouter(this._authBloc, {List<RouteBase> extraRoutes = const []}) : _extraRoutes = extraRoutes;

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthBlocListenable(_authBloc),
    redirect: (context, state) {
      final authState = _authBloc.state;
      final loggingIn = state.matchedLocation == '/login';
      final signingUp = state.matchedLocation == '/signup';

      if (authState is Unauthenticated || authState is AuthInitial) {
        if (loggingIn || signingUp) return null;
        return '/login';
      }

      if (authState is Authenticated) {
        if (loggingIn || signingUp) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, authState) {
            return AdminLoginView(
              isLoading: authState is AuthLoading,
              errorMessage: authState is AuthFailure ? authState.message : null,
              onEmailLogin: (email, password) => _authBloc.add(AuthLoggedIn(email, password)),
              onPhoneSignIn: (phone) => _authBloc.add(AuthPhoneSignInRequested(phone)),
              onVerifyOTP: (phone, otp) => _authBloc.add(AuthOTPVerifyRequested(phone, otp)),
              onGoogleLogin: () => _authBloc.add(AuthGoogleSignInRequested()),
              onAppleLogin: () => _authBloc.add(AuthAppleSignInRequested()),
            );
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, authState) {
            return PremiumSignupView(
              isLoading: authState is AuthLoading,
              errorMessage: authState is AuthFailure ? authState.message : null,
              onSignup: (name, email, password) => _authBloc.add(AuthSignedUp(
                name: name,
                email: email,
                password: password,
              )),
              onBackToLogin: () => context.go('/login'),
            );
          },
        ),
      ),
      ..._extraRoutes,
    ],
  );
}

class _AuthBlocListenable extends ChangeNotifier {
  _AuthBlocListenable(AuthBloc bloc) {
    bloc.stream.listen((_) => notifyListeners());
  }
}
