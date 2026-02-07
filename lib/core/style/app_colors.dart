import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color primary;
  final Color secondary;
  final Color divider;
  final Color shadow;
  final Color onPrimary;
  final Color success;
  final Color border;
  final Color error;

  const AppColors({
    required this.background,
    required this.border,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.secondary,
    required this.shadow,
    required this.divider,
    required this.success,
    required this.error,
    required this.onPrimary,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFF3B4953),
    surface: Color(0xFFEBF4DD),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B7280),
    primary: Color(0xFF90AB8B),
    secondary: Color(0xFF5A7863),
    divider: Color(0xFFE5E7EB),
    shadow: Color(0x1A000000),
    onPrimary: Colors.white,
    success: Color(0xFF16A34A),
    border: Color(0xFFE5E7EB),
    error: Color(0xFFDC2626),
  );

  static const dark = AppColors(
    background: Color(0xFF121417),
    surface: Color(0xFF1C1F24),
    textPrimary: Color(0xFFE6E6E6),
    textSecondary: Color(0xFF9CA3AF),
    primary: Color(0xFF8FA8FF),
    secondary: Color(0xFF3E4A74),
    divider: Color(0xFF2A2E35),
    shadow: Color(0x33000000),
    onPrimary: Colors.black,
    success: Color(0xFF22C55E),
    border: Color(0xFF374151),
    error: Color(0xFFF87171),
  );
}
