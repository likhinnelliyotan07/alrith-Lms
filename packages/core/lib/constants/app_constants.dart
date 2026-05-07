class AppConstants {
  const AppConstants._();

  static const String appName = 'Arlith LMS';
  static const double horizontalPadding = 20.0;
  static const double verticalPadding = 20.0;
  static const double borderRadius = 16.0;
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration slowAnimation = Duration(milliseconds: 800);

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String tenantConfigKey = 'tenant_config';
}
