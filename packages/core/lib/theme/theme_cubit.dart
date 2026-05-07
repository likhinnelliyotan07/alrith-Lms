import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../white_label/app_config.dart';
import '../constants/app_colors.dart';

part 'theme_state.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }

  void updateConfig(AppConfig config) {
    emit(state.copyWith(config: config));
  }
}
