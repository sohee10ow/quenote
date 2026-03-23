import '../enums/app_text_size.dart';
import '../enums/app_theme_type.dart';
import '../enums/share_format_type.dart';

class UserSettings {
  const UserSettings({
    required this.selectedTheme,
    required this.textSize,
    required this.defaultShareFormat,
    required this.onboardingCompleted,
  });

  final AppThemeType selectedTheme;
  final AppTextSize textSize;
  final ShareFormatType defaultShareFormat;
  final bool onboardingCompleted;

  const UserSettings.initial()
    : selectedTheme = AppThemeType.sage,
      textSize = AppTextSize.medium,
      defaultShareFormat = ShareFormatType.full,
      onboardingCompleted = false;

  UserSettings copyWith({
    AppThemeType? selectedTheme,
    AppTextSize? textSize,
    ShareFormatType? defaultShareFormat,
    bool? onboardingCompleted,
  }) {
    return UserSettings(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      textSize: textSize ?? this.textSize,
      defaultShareFormat: defaultShareFormat ?? this.defaultShareFormat,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
