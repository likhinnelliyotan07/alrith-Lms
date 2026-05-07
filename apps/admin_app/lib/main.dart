import 'package:core/network/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'di/injection.dart' as admin_di;
import 'di/injection.dart';

void main() async {
  await ArlithCore.initialize();
  admin_di.configureAppDependencies();
  runApp(const AdminApp());
}


class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<AuthBloc>()..add(AuthCheckRequested())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final router = admin_di.getIt<AppRouter>().router;
          return MaterialApp.router(
            title: AppStrings.adminDashboard,
            theme: state.themeData,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

