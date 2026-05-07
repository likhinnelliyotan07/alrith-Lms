import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:core/di/injection.dart';
import 'package:core/network/app_router.dart';

void main() async {
  await ArlithCore.initialize();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(

        builder: (context, state) {
          final router = getIt<AppRouter>().router;
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
