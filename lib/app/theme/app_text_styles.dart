import 'package:flutter/material.dart';

TextTheme buildAppTextTheme(Color textPrimary, Color textSecondary) {
  const fallbackFonts = <String>['Apple SD Gothic Neo', 'Noto Sans CJK KR'];

  return TextTheme(
    displayLarge: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontFamilyFallback: fallbackFonts,
    ).copyWith(color: textPrimary),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      fontFamilyFallback: fallbackFonts,
    ).copyWith(color: textPrimary),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamilyFallback: fallbackFonts,
    ).copyWith(color: textPrimary),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.6,
      fontFamilyFallback: fallbackFonts,
    ).copyWith(color: textPrimary),
    bodyMedium: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.6,
      fontFamilyFallback: fallbackFonts,
    ).copyWith(color: textSecondary),
  );
}
