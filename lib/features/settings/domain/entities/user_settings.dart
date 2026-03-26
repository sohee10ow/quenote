import '../enums/app_plan_type.dart';
import '../enums/app_text_size.dart';
import '../enums/app_theme_type.dart';
import '../enums/share_format_type.dart';

class UserSettings {
  const UserSettings({
    required this.planType,
    required this.betaProOverrideEnabled,
    required this.selectedTheme,
    required this.textSize,
    required this.defaultShareFormat,
    required this.onboardingCompleted,
  });

  final AppPlanType planType;
  final bool betaProOverrideEnabled;
  final AppThemeType selectedTheme;
  final AppTextSize textSize;
  final ShareFormatType defaultShareFormat;
  final bool onboardingCompleted;

  const UserSettings.initial()
    : planType = AppPlanType.free,
      betaProOverrideEnabled = false,
      selectedTheme = AppThemeType.sage,
      textSize = AppTextSize.medium,
      defaultShareFormat = ShareFormatType.full,
      onboardingCompleted = false;

  UserSettings copyWith({
    AppPlanType? planType,
    bool? betaProOverrideEnabled,
    AppThemeType? selectedTheme,
    AppTextSize? textSize,
    ShareFormatType? defaultShareFormat,
    bool? onboardingCompleted,
  }) {
    return UserSettings(
      planType: planType ?? this.planType,
      betaProOverrideEnabled:
          betaProOverrideEnabled ?? this.betaProOverrideEnabled,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      textSize: textSize ?? this.textSize,
      defaultShareFormat: defaultShareFormat ?? this.defaultShareFormat,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
