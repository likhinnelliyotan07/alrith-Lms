import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'app_config.dart';
import '../theme/theme_cubit.dart';

@lazySingleton
class WhiteLabelController {
  final ThemeCubit _themeCubit;

  WhiteLabelController(this._themeCubit);

  void setTenantConfig(AppConfig config) {
    _themeCubit.updateConfig(config);
  }

  // Helper to get current config
  AppConfig? get currentConfig => _themeCubit.state.config;

  // Static method to create a default config (useful for development)
  static AppConfig get devConfig => const AppConfig(
        tenantId: 'dev-tenant',
        appName: 'Arlith LMS Dev',
        logoAsset: 'assets/images/logo.png',
        primaryColorHex: '#6366F1',
        secondaryColorHex: '#06B6D4',
        fontFamily: 'Outfit',
      );
}
