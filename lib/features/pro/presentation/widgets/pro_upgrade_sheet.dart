import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

Future<bool> showProUpgradeSheet(
  BuildContext context, {
  required String title,
  required String description,
  required Future<void> Function() onEnableBetaPro,
}) async {
  final enabled = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ProUpgradeSheet(
        title: title,
        description: description,
        onEnableBetaPro: onEnableBetaPro,
      );
    },
  );

  return enabled ?? false;
}

class _ProUpgradeSheet extends StatelessWidget {
  const _ProUpgradeSheet({
    required this.title,
    required this.description,
    required this.onEnableBetaPro,
  });

  final String title;
  final String description;
  final Future<void> Function() onEnableBetaPro;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  CupertinoIcons.sparkles,
                  size: 24,
                  color: primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _BenefitRow(label: '시퀀스 무제한 저장'),
              const SizedBox(height: AppSpacing.sm),
              const _BenefitRow(label: '동작 사진 첨부와 수정'),
              const SizedBox(height: AppSpacing.sm),
              const _BenefitRow(label: '시퀀스와 동작 복제'),
              const SizedBox(height: AppSpacing.sm),
              const _BenefitRow(label: 'JSON 백업과 복원'),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('닫기'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await onEnableBetaPro();
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text('베타 Pro 켜기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            CupertinoIcons.check_mark,
            size: 14,
            color: primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
