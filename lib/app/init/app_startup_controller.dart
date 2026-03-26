import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_provider.dart';
import '../../features/settings/data/local/isar_user_settings.dart';
import '../../features/settings/domain/entities/user_settings.dart';
import '../../features/settings/domain/enums/app_plan_type.dart';
import '../../features/settings/domain/enums/app_text_size.dart';
import '../../features/settings/domain/enums/app_theme_type.dart';
import '../../features/settings/domain/enums/share_format_type.dart';

final userSettingsControllerProvider =
    AsyncNotifierProvider<UserSettingsController, UserSettings>(
      UserSettingsController.new,
    );

class UserSettingsController extends AsyncNotifier<UserSettings> {
  @override
  Future<UserSettings> build() async {
    final isar = await ref.watch(isarProvider.future);
    final stored = await isar.isarUserSettingsModels.get(0);

    if (stored != null) {
      return stored.toDomain();
    }

    const initial = UserSettings.initial();
    await isar.writeTxn(() async {
      await isar.isarUserSettingsModels.put(initial.toIsar());
    });

    return initial;
  }

  Future<void> setTheme(AppThemeType theme) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(selectedTheme: theme);
    await _persist(next);
    state = AsyncData(next);
  }

  Future<void> setTextSize(AppTextSize textSize) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(textSize: textSize);
    await _persist(next);
    state = AsyncData(next);
  }

  Future<void> setShareFormat(ShareFormatType shareFormat) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(defaultShareFormat: shareFormat);
    await _persist(next);
    state = AsyncData(next);
  }

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(onboardingCompleted: true);
    await _persist(next);
    state = AsyncData(next);
  }

  Future<void> _persist(UserSettings settings) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.isarUserSettingsModels.put(settings.toIsar());
    });
  }

  Future<void> setPlanType(AppPlanType planType) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(planType: planType);
    await _persist(next);
    state = AsyncData(next);
  }

  Future<void> setBetaProOverrideEnabled(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final next = current.copyWith(betaProOverrideEnabled: enabled);
    await _persist(next);
    state = AsyncData(next);
  }
}

final appThemeTypeProvider = Provider<AppThemeType>((ref) {
  final settings = ref.watch(userSettingsControllerProvider);
  return settings.valueOrNull?.selectedTheme ?? AppThemeType.sage;
});

final appTextScaleFactorProvider = Provider<double>((ref) {
  final settings = ref.watch(userSettingsControllerProvider);
  final textSize = settings.valueOrNull?.textSize ?? AppTextSize.medium;

  switch (textSize) {
    case AppTextSize.small:
      return 0.94;
    case AppTextSize.medium:
      return 1.0;
    case AppTextSize.large:
      return 1.1;
  }
});

final appShareFormatProvider = Provider<ShareFormatType>((ref) {
  final settings = ref.watch(userSettingsControllerProvider);
  return settings.valueOrNull?.defaultShareFormat ?? ShareFormatType.full;
});

final isProEnabledProvider = Provider<bool>((ref) {
  final settings = ref.watch(userSettingsControllerProvider);
  final current = settings.valueOrNull ?? const UserSettings.initial();
  return current.planType == AppPlanType.pro || current.betaProOverrideEnabled;
});
