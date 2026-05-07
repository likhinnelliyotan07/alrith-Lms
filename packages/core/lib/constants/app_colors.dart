import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Primary Colors (Premium Indigo/Blue)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors (Vibrant Teal/Cyan)
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  // Accent Colors
  static const Color accent = Color(0xFFF43F5E);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);

  // Glassmorphism Colors
  static Color glassBackground = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}
