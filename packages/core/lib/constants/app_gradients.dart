import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondary = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glass = LinearGradient(
    colors: [
      Colors.white10,
      Colors.white12,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premium = LinearGradient(
    colors: [
      Color(0xFF6366F1),
      Color(0xFFA855F7),
      Color(0xFFEC4899),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adminLeftSection = LinearGradient(
    colors: [
      Color(0xFFE0E7FF),
      Color(0xFFF5F3FF),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient adminLeftSectionDark = LinearGradient(
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF312E81),
      Color(0xFF1E1B4B),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient adminPrimaryGradient = LinearGradient(
    colors: [
      Color(0xFF0052FF),
      Color(0xFF4F46E5),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient adminDarkButton = LinearGradient(
    colors: [
      Color(0xFF9333EA),
      Color(0xFF4F46E5),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
