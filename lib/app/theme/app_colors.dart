import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.primary,
    required this.scaffoldBackground,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.success,
  });

  final Color primary;
  final Color scaffoldBackground;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;
  final Color success;
}

abstract final class AppPalettes {
  static const sage = AppPalette(
    primary: Color(0xFF8FA88E),
    scaffoldBackground: Color(0xFFF5F7F5),
    card: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF2C3E2E),
    textSecondary: Color(0xFF6B7A6D),
    error: Color(0xFFE89D91),
    success: Color(0xFF86A89B),
  );

  static const sand = AppPalette(
    primary: Color(0xFFC9B5A0),
    scaffoldBackground: Color(0xFFF7F5F2),
    card: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF3E3632),
    textSecondary: Color(0xFF7A716B),
    error: Color(0xFFE89D91),
    success: Color(0xFF86A89B),
  );
}
