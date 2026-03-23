import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/init/app_startup_controller.dart';
import '../../../app/theme/app_spacing.dart';
import '../domain/entities/user_settings.dart';
import '../domain/enums/app_text_size.dart';
import '../domain/enums/app_theme_type.dart';
import '../domain/enums/share_format_type.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (settingsAsync.hasError) {
              return _SettingsErrorView(
                onRetry: () => ref.invalidate(userSettingsControllerProvider),
              );
            }

            final settings = settingsAsync.valueOrNull;
            if (settings == null) {
              return Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            }

            return Column(
              children: [
                _SettingsHeader(
                  onBack: () {
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      navigator.pop();
                    }
                  },
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 32),
                    children: [
                      _SettingsSection(
                        title: '화면 및 디자인',
                        children: [
                          _SettingsRow(
                            icon: Icons.palette_outlined,
                            label: '앱 테마',
                            value: _themeLabel(settings.selectedTheme),
                            hasChevron: true,
                            onTap: () =>
                                _showThemeSheet(context, ref, settings),
                          ),
                          _SettingsRow(
                            icon: Icons.text_fields_rounded,
                            label: '텍스트 크기',
                            value: _textSizeLabel(settings.textSize),
                            hasChevron: true,
                            onTap: () =>
                                _showTextSizeSheet(context, ref, settings),
                            showDivider: false,
                          ),
                        ],
                      ),
                      _SettingsSection(
                        title: '데이터 및 공유',
                        children: [
                          _SettingsRow(
                            icon: Icons.ios_share_rounded,
                            label: '기본 공유 형식',
                            value: _shareFormatLabel(
                              settings.defaultShareFormat,
                            ),
                            hasChevron: true,
                            onTap: () =>
                                _showShareFormatSheet(context, ref, settings),
                          ),
                          _SettingsRow(
                            icon: Icons.cloud_download_outlined,
                            label: '요가 시퀀스 내보내기',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('내보내기 기능은 준비 중입니다.'),
                                ),
                              );
                            },
                            showDivider: false,
                          ),
                        ],
                      ),
                      _SettingsSection(
                        title: '앱 정보',
                        children: const [
                          _SettingsRow(
                            icon: Icons.info_outline_rounded,
                            label: '버전 정보',
                            value: '최신 버전 (1.0.0)',
                            showDivider: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showThemeSheet(
    BuildContext context,
    WidgetRef ref,
    UserSettings settings,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('앱 테마'),
          actions: AppThemeType.values
              .map((themeType) {
                return CupertinoActionSheetAction(
                  isDefaultAction: themeType == settings.selectedTheme,
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await ref
                        .read(userSettingsControllerProvider.notifier)
                        .setTheme(themeType);
                  },
                  child: Text(_themeLabel(themeType)),
                );
              })
              .toList(growable: false),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );
  }

  Future<void> _showTextSizeSheet(
    BuildContext context,
    WidgetRef ref,
    UserSettings settings,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('텍스트 크기'),
          actions: AppTextSize.values
              .map((textSize) {
                return CupertinoActionSheetAction(
                  isDefaultAction: textSize == settings.textSize,
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await ref
                        .read(userSettingsControllerProvider.notifier)
                        .setTextSize(textSize);
                  },
                  child: Text(_textSizeLabel(textSize)),
                );
              })
              .toList(growable: false),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );
  }

  Future<void> _showShareFormatSheet(
    BuildContext context,
    WidgetRef ref,
    UserSettings settings,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('기본 공유 형식'),
          actions: ShareFormatType.values
              .map((shareFormat) {
                return CupertinoActionSheetAction(
                  isDefaultAction: shareFormat == settings.defaultShareFormat,
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await ref
                        .read(userSettingsControllerProvider.notifier)
                        .setShareFormat(shareFormat);
                  },
                  child: Text(_shareFormatLabel(shareFormat)),
                );
              })
              .toList(growable: false),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );
  }

  static String _themeLabel(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.sage:
        return '세이지 그린';
      case AppThemeType.sand:
        return '샌드 베이지';
    }
  }

  static String _textSizeLabel(AppTextSize textSize) {
    switch (textSize) {
      case AppTextSize.small:
        return '작게';
      case AppTextSize.medium:
        return '보통';
      case AppTextSize.large:
        return '크게';
    }
  }

  static String _shareFormatLabel(ShareFormatType shareFormat) {
    switch (shareFormat) {
      case ShareFormatType.full:
        return '전체 시퀀스';
      case ShareFormatType.cues:
        return '큐잉만';
      case ShareFormatType.short:
        return '짧은 요약';
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.03),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(CupertinoIcons.back, size: 24),
                ),
              ),
            ),
          ),
          Text(
            '설정',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 40, height: 40),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.9,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.hasChevron = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool hasChevron;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(
                    bottom: BorderSide(
                      color: Colors.black.withValues(alpha: 0.04),
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.02),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  value!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.88,
                    ),
                  ),
                ),
              ],
              if (hasChevron) ...[
                const SizedBox(width: 10),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsErrorView extends StatelessWidget {
  const _SettingsErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 28,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('설정을 불러오지 못했습니다.', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('잠시 후 다시 시도해주세요.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
