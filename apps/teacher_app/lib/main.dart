import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';
import 'package:core/di/injection.dart';
import 'package:core/network/app_router.dart';

void main() async {
  await ArlithCore.initialize();
  runApp(const TeacherApp());
}

class TeacherApp extends StatelessWidget {
  const TeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider.value(
          value: getIt<ThemeCubit>(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final router = getIt<AppRouter>().router;
              return MaterialApp.router(
                title: AppStrings.teacherDashboard,
                theme: state.themeData,
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}
