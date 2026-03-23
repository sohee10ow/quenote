import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/init/app_startup_controller.dart';
import '../../../app/theme/app_spacing.dart';
import '../../settings/domain/enums/app_theme_type.dart';
import 'widgets/theme_selection_card.dart';

class ThemeSelectionPlaceholderScreen extends ConsumerWidget {
  const ThemeSelectionPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsControllerProvider);
    final selectedTheme =
        settingsAsync.valueOrNull?.selectedTheme ?? AppThemeType.sage;

    const sagePrimary = Color(0xFF8FA88E);
    const sageDeep = Color(0xFF5F7D64);
    const sageBg = Color(0xFFF5F7F5);
    const sandPrimary = Color(0xFFC9B5A0);
    const sandDeep = Color(0xFF8E7D6D);
    const sandBg = Color(0xFFF7F5F2);

    final ctaColor = selectedTheme == AppThemeType.sage ? sageDeep : sandDeep;

    return Scaffold(
      backgroundColor: selectedTheme == AppThemeType.sage ? sageBg : sandBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '앱 테마 설정',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '요가 수련의 분위기를 담은\n두 가지 테마 중 하나를 선택해주세요.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ThemeSelectionCard(
                      title: '세이지 그린',
                      description: '새벽의 요가원처럼 차분하고 평온한 무드',
                      selected: selectedTheme == AppThemeType.sage,
                      tint: sagePrimary,
                      previewBase: const Color(0xFFE4ECE3),
                      previewAccent: const Color(0xFF7F9A7E),
                      swatches: const [
                        Color(0xFF8FA88E),
                        Color(0xFFF5F7F5),
                        Color(0xFF2C3E2E),
                      ],
                      onTap: () {
                        ref
                            .read(userSettingsControllerProvider.notifier)
                            .setTheme(AppThemeType.sage);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ThemeSelectionCard(
                      title: '샌드 베이지',
                      description: '따스한 오후의 햇살처럼 부드러운 무드',
                      selected: selectedTheme == AppThemeType.sand,
                      tint: sandPrimary,
                      previewBase: const Color(0xFFEFE8DF),
                      previewAccent: const Color(0xFFB6A18D),
                      swatches: const [
                        Color(0xFFC9B5A0),
                        Color(0xFFF7F5F2),
                        Color(0xFF3E3632),
                      ],
                      onTap: () {
                        ref
                            .read(userSettingsControllerProvider.notifier)
                            .setTheme(AppThemeType.sand);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: ctaColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    await ref
                        .read(userSettingsControllerProvider.notifier)
                        .completeOnboarding();
                  },
                  child: Text(
                    '시작하기',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
