import 'package:flutter/material.dart';

import '../../features/settings/domain/enums/app_theme_type.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData fromType(AppThemeType type) {
    switch (type) {
      case AppThemeType.sand:
        return _build(AppPalettes.sand);
      case AppThemeType.sage:
        return _build(AppPalettes.sage);
    }
  }

  static ThemeData _build(AppPalette palette) {
    final textTheme = buildAppTextTheme(
      palette.textPrimary,
      palette.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.scaffoldBackground,
      cardColor: palette.card,
      colorScheme: ColorScheme.light(
        primary: palette.primary,
        secondary: palette.primary,
        error: palette.error,
        surface: palette.card,
        onPrimary: Colors.white,
        onSurface: palette.textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.scaffoldBackground,
        foregroundColor: palette.textPrimary,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: palette.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(AppRadius.card),
        ),
        elevation: 0.5,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(AppRadius.input),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.card,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textPrimary,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: AppRadius.bottomSheetTop),
        ),
      ),
    );
  }
}
