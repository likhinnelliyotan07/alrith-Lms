import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => PremiumLoginView(
          onLogin: () => context.go('/'),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Arlith LMS Root')),
        ),
      ),
    ],
  );
}

