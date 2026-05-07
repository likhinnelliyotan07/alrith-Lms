import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;

  const SharedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Default design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          appBar: appBar != null ? PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: appBar!,
          ) : null,
          drawer: drawer,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        );
      },
    );
  }
}
