import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../white_label/app_config.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

part 'theme_state.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  static const String _boxName = 'theme_box';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final box = await Hive.openBox(_boxName);
    final modeIndex = box.get(AppConstants.themeModeKey, defaultValue: ThemeMode.light.index);
    final configJson = box.get(AppConstants.tenantConfigKey);

    AppConfig? config;
    if (configJson != null) {
      config = AppConfig.fromJson(jsonDecode(configJson as String));
    }

    emit(state.copyWith(
      themeMode: ThemeMode.values[modeIndex as int],
      config: config,
    ));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final box = await Hive.openBox(_boxName);
    await box.put(AppConstants.themeModeKey, newMode.index);
    emit(state.copyWith(themeMode: newMode));
  }

  Future<void> updateConfig(AppConfig config) async {
    final box = await Hive.openBox(_boxName);
    await box.put(AppConstants.tenantConfigKey, jsonEncode(config.toJson()));
    emit(state.copyWith(config: config));
  }
}

