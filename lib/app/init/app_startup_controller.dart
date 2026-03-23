import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_provider.dart';
import '../../features/settings/data/local/isar_user_settings.dart';
import '../../features/settings/domain/entities/user_settings.dart';
import '../../features/settings/domain/enums/app_theme_type.dart';

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
}

final appThemeTypeProvider = Provider<AppThemeType>((ref) {
  final settings = ref.watch(userSettingsControllerProvider);
  return settings.valueOrNull?.selectedTheme ?? AppThemeType.sage;
});
