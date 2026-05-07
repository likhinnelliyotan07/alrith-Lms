part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final AppConfig? config;

  const ThemeState({
    required this.themeMode,
    this.config,
  });

  ThemeData get themeData {
    final primaryColor = config?.primaryColor ?? AppColors.primary;
    final secondaryColor = config?.secondaryColor ?? AppColors.secondary;
    final isDark = themeMode == ThemeMode.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        surface: isDark ? AppColors.darkSurface : AppColors.surface,
        onSurface: isDark ? Colors.white : Colors.black,
      ),
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      fontFamily: config?.fontFamily ?? 'Inter',
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? AppColors.darkSurface : AppColors.surface,
      ),

      // Add more theme customizations for premium feel
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppConfig? config,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [themeMode, config];
}
