import 'package:isar/isar.dart';

import '../../domain/entities/user_settings.dart';
import '../../domain/enums/app_text_size.dart';
import '../../domain/enums/app_theme_type.dart';
import '../../domain/enums/share_format_type.dart';

part 'isar_user_settings.g.dart';

@collection
class IsarUserSettingsModel {
  IsarUserSettingsModel();

  Id id = 0;
  String selectedTheme = AppThemeType.sage.name;
  String textSize = AppTextSize.medium.name;
  String defaultShareFormat = ShareFormatType.full.name;
  bool onboardingCompleted = false;
}

extension IsarUserSettingsMapper on IsarUserSettingsModel {
  UserSettings toDomain() {
    return UserSettings(
      selectedTheme: AppThemeType.values.firstWhere(
        (value) => value.name == selectedTheme,
        orElse: () => AppThemeType.sage,
      ),
      textSize: AppTextSize.values.firstWhere(
        (value) => value.name == textSize,
        orElse: () => AppTextSize.medium,
      ),
      defaultShareFormat: ShareFormatType.values.firstWhere(
        (value) => value.name == defaultShareFormat,
        orElse: () => ShareFormatType.full,
      ),
      onboardingCompleted: onboardingCompleted,
    );
  }
}

extension DomainUserSettingsMapper on UserSettings {
  IsarUserSettingsModel toIsar([Id id = 0]) {
    final model = IsarUserSettingsModel()
      ..id = id
      ..selectedTheme = selectedTheme.name
      ..textSize = textSize.name
      ..defaultShareFormat = defaultShareFormat.name
      ..onboardingCompleted = onboardingCompleted;
    return model;
  }
}
