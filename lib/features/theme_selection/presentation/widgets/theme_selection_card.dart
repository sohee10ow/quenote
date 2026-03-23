import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class ThemeSelectionCard extends StatelessWidget {
  const ThemeSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.tint,
    required this.previewBase,
    required this.previewAccent,
    required this.swatches,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final Color tint;
  final Color previewBase;
  final Color previewAccent;
  final List<Color> swatches;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary =
        Theme.of(context).textTheme.bodyMedium?.color ?? textPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected
              ? Color.alphaBlend(tint.withValues(alpha: 0.08), cardColor)
              : cardColor,
          borderRadius: const BorderRadius.all(AppRadius.card),
          border: Border.all(
            color: selected ? tint : Colors.black.withValues(alpha: 0.1),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Row(
                  children: swatches
                      .map(
                        (color) => Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 96,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: previewBase,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 10,
                    decoration: BoxDecoration(
                      color: previewAccent.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.82),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: previewAccent.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  selected ? '선택됨' : '선택하기',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected ? tint : textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? tint : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? tint
                          : Colors.black.withValues(alpha: 0.2),
                      width: 1.4,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.95),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
