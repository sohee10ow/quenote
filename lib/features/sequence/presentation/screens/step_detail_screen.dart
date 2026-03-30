import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../../pro/application/pro_access.dart';
import '../../application/sequence_providers.dart';
import '../../application/step_template_providers.dart';
import '../../domain/entities/sequence.dart';
import '../../domain/entities/sequence_step.dart';
import '../../domain/enums/side_type.dart';
import '../../domain/enums/step_template_category.dart';
import '../args/sequence_route_args.dart';

class StepDetailScreen extends ConsumerWidget {
  const StepDetailScreen({
    super.key,
    required this.sequenceId,
    required this.stepId,
  });

  final int sequenceId;
  final int stepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequenceAsync = ref.watch(sequenceByIdProvider(sequenceId));
    final stepsAsync = ref.watch(sequenceStepsProvider(sequenceId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (sequenceAsync.hasError || stepsAsync.hasError) {
              return const Center(child: Text('불러오기에 실패했습니다.'));
            }

            final sequence = sequenceAsync.valueOrNull;
            final steps = stepsAsync.valueOrNull;

            if (sequenceAsync.isLoading || stepsAsync.isLoading) {
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

            if (sequence == null || steps == null) {
              return const Center(child: Text('동작을 찾을 수 없습니다.'));
            }

            final step = steps.where((item) => item.id == stepId).firstOrNull;
            if (step == null || step.sequenceId != sequence.id) {
              return const Center(child: Text('동작을 찾을 수 없습니다.'));
            }

            return _StepDetailContent(
              sequence: sequence,
              step: step,
              onOpenMenu: () => _showActionMenu(context, ref, sequence, step),
            );
          },
        ),
      ),
    );
  }

  void _openStepEditor(BuildContext context, int sequenceId, int stepId) {
    Navigator.of(context).pushNamed(
      AppRoutes.stepEditor,
      arguments: StepEditorRouteArgs(sequenceId: sequenceId, stepId: stepId),
    );
  }

  Future<void> _showActionMenu(
    BuildContext context,
    WidgetRef ref,
    Sequence sequence,
    SequenceStep step,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                _openStepEditor(context, sequence.id, step.id);
              },
              child: const Text('수정'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await _showTemplateCategorySheet(context, ref, step);
              },
              child: const Text('즐겨찾기에 저장'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await _showDuplicateOptions(context, ref, sequence, step);
              },
              child: const Text('동작 복제'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );
  }

  Future<void> _showTemplateCategorySheet(
    BuildContext context,
    WidgetRef ref,
    SequenceStep step,
  ) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('즐겨찾기에 저장'),
          message: const Text('동작 템플릿 카테고리를 선택하세요.'),
          actions: StepTemplateCategory.values
              .map((category) {
                return CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await _saveStepAsTemplate(context, ref, step, category);
                  },
                  child: Text(category.label),
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

  Future<void> _saveStepAsTemplate(
    BuildContext context,
    WidgetRef ref,
    SequenceStep step,
    StepTemplateCategory category,
  ) async {
    try {
      final repository = ref.read(sequenceRepositoryProvider);
      final templateId = await repository.saveStepAsTemplate(
        stepId: step.id,
        category: category,
      );

      ref.invalidate(stepTemplateListProvider(null));
      for (final item in StepTemplateCategory.values) {
        ref.invalidate(stepTemplateListProvider(item));
      }
      ref.invalidate(stepTemplateByIdProvider(templateId));

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('즐겨찾기에 저장했어요.')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('템플릿 저장에 실패했습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }

  Future<void> _duplicateStep(
    BuildContext context,
    WidgetRef ref,
    Sequence sequence,
    int stepId,
  ) async {
    try {
      final repository = ref.read(sequenceRepositoryProvider);
      final result = await repository.duplicateStepIntoSameSequence(stepId);

      _invalidateSequenceCaches(ref, sequence.id, result.targetSequenceId);

      if (!context.mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
        return;
      }

      navigator.pushReplacementNamed(
        AppRoutes.sequenceDetail,
        arguments: SequenceDetailRouteArgs(sequenceId: result.targetSequenceId),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE89D91),
          content: Text('동작을 복제하지 못했습니다. 다시 시도해주세요.'),
        ),
      );
    }
  }

  Future<void> _showDuplicateOptions(
    BuildContext context,
    WidgetRef ref,
    Sequence sequence,
    SequenceStep step,
  ) async {
    final allowed = await ref
        .read(proAccessGuardProvider)
        .ensureFeatureAccess(context, ProFeature.stepDuplication);
    if (!allowed || !context.mounted) {
      return;
    }

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('동작 복제'),
          message: const Text('복제할 위치를 선택하세요.'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                await _duplicateStep(context, ref, sequence, step.id);
              },
              child: const Text('현재 시퀀스에 넣기'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.sequenceEditor,
                  arguments: SequenceEditorRouteArgs(
                    pendingDuplicateSourceStepId: step.id,
                  ),
                );
              },
              child: const Text('새로운 시퀀스에 넣기'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.stepDuplicateTarget,
                  arguments: StepDuplicateTargetRouteArgs(
                    sourceSequenceId: sequence.id,
                    sourceStepId: step.id,
                  ),
                );
              },
              child: const Text('다른 시퀀스에 넣기'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('취소'),
          ),
        );
      },
    );
  }

  void _invalidateSequenceCaches(
    WidgetRef ref,
    int sourceSequenceId,
    int targetSequenceId,
  ) {
    ref.invalidate(sequenceStepsProvider(sourceSequenceId));
    ref.invalidate(sequenceByIdProvider(sourceSequenceId));
    ref.invalidate(sequenceStepsProvider(targetSequenceId));
    ref.invalidate(sequenceByIdProvider(targetSequenceId));
    ref.invalidate(sequenceListProvider);
    ref.invalidate(sequenceStepCountsProvider);
    ref.invalidate(favoriteSequenceListProvider);
    ref.invalidate(recentSequenceListProvider);
    ref.invalidate(homeOverviewProvider);
  }
}

class _StepDetailContent extends StatelessWidget {
  const _StepDetailContent({
    required this.sequence,
    required this.step,
    required this.onOpenMenu,
  });

  final Sequence sequence;
  final SequenceStep step;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      if (step.imagePaths.isNotEmpty)
        _StepImageSection(imagePaths: step.imagePaths),
      if (step.preparationCue.trim().isNotEmpty)
        _BodySectionCard(
          title: '준비동작 큐잉',
          child: Text(step.preparationCue.trim(), style: _bodyStyle(context)),
        ),
      if (_filledBreathCues(step).isNotEmpty) _BreathCueSection(step: step),
      if (step.releaseCue.trim().isNotEmpty)
        _BodySectionCard(
          title: '동작 푸는 큐잉',
          child: Text(step.releaseCue.trim(), style: _bodyStyle(context)),
        ),
      if ((step.cautionNote ?? '').trim().isNotEmpty)
        _HighlightedSectionCard(
          title: '주의사항',
          icon: CupertinoIcons.exclamationmark_circle,
          accentBackground: const Color(0x14F59E0B),
          iconBackground: const Color(0xFFFDE68A),
          iconColor: const Color(0xFFD97706),
          body: step.cautionNote!.trim(),
        ),
      if ((step.beginnerModificationNote ?? '').trim().isNotEmpty)
        _HighlightedSectionCard(
          title: '초보자 변형 동작',
          icon: CupertinoIcons.info_circle,
          accentBackground: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.06),
          iconBackground: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.2),
          iconColor: Theme.of(context).colorScheme.primary,
          body: step.beginnerModificationNote!.trim(),
        ),
      if (!_hasAnyContent(step))
        _StepEmptyState(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.stepEditor,
              arguments: StepEditorRouteArgs(
                sequenceId: sequence.id,
                stepId: step.id,
              ),
            );
          },
        ),
    ];

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _StepHeaderCard(sequence: sequence, step: step, onOpenMenu: onOpenMenu),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: List<Widget>.generate(sections.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == sections.length - 1 ? 0 : AppSpacing.xl,
                ),
                child: sections[index],
              );
            }),
          ),
        ),
      ],
    );
  }

  static Iterable<String> _filledBreathCues(SequenceStep step) {
    return step.breathCues
        .map((cue) => cue.text.trim())
        .where((text) => text.isNotEmpty);
  }

  static bool _hasAnyContent(SequenceStep step) {
    return step.imagePaths.isNotEmpty ||
        step.preparationCue.trim().isNotEmpty ||
        step.releaseCue.trim().isNotEmpty ||
        step.breathCues.any((cue) => cue.text.trim().isNotEmpty) ||
        (step.cautionNote ?? '').trim().isNotEmpty ||
        (step.beginnerModificationNote ?? '').trim().isNotEmpty;
  }

  static TextStyle? _bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 15,
      height: 1.7,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}

class _StepImageSection extends StatelessWidget {
  const _StepImageSection({required this.imagePaths});

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _BodySectionCard(
      title: '동작 사진',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imagePaths.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final path = imagePaths[index];
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _MissingImagePlaceholder(theme: theme);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepHeaderCard extends StatelessWidget {
  const _StepHeaderCard({
    required this.sequence,
    required this.step,
    required this.onOpenMenu,
  });

  final Sequence sequence;
  final SequenceStep step;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleIconButton(
                  icon: CupertinoIcons.back,
                  onTap: () {
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      navigator.pop();
                    } else {
                      navigator.pushReplacementNamed(
                        AppRoutes.sequenceDetail,
                        arguments: SequenceDetailRouteArgs(
                          sequenceId: sequence.id,
                        ),
                      );
                    }
                  },
                ),
                _CircleIconButton(
                  icon: CupertinoIcons.ellipsis_circle,
                  filled: true,
                  onTap: onOpenMenu,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${step.orderIndex + 1}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.poseName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              sequence.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _MetaChip(
                  icon: CupertinoIcons.wind,
                  label: '${step.breathCount}호흡',
                ),
                if (step.sideType != SideType.none)
                  _MetaChip(
                    icon: CupertinoIcons.location_solid,
                    label: _sideLabel(step.sideType),
                  ),
                if (step.isBalancePose)
                  _MetaChip(
                    icon: Icons.balance_rounded,
                    label: '밸런스 동작',
                    isAccent: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _sideLabel(SideType sideType) {
    switch (sideType) {
      case SideType.left:
        return '왼쪽';
      case SideType.right:
        return '오른쪽';
      case SideType.both:
        return '양쪽';
      case SideType.none:
        return '없음';
    }
  }
}

class _MissingImagePlaceholder extends StatelessWidget {
  const _MissingImagePlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.photo,
              size: 28,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.35),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '이미지 파일을 찾을 수 없어요',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = filled
        ? theme.colorScheme.primary
        : theme.scaffoldBackgroundColor;
    final foreground = filled
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: foreground),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.isAccent = false,
  });

  final IconData icon;
  final String label;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final background = isAccent
        ? primary.withValues(alpha: 0.1)
        : theme.scaffoldBackgroundColor;
    final foreground = isAccent ? primary : theme.textTheme.bodyMedium?.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _BodySectionCard extends StatelessWidget {
  const _BodySectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathCueSection extends StatelessWidget {
  const _BreathCueSection({required this.step});

  final SequenceStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final cues = step.breathCues
        .where((cue) => cue.text.trim().isNotEmpty)
        .toList(growable: false);

    return _BodySectionCard(
      title: '호흡 큐잉',
      child: Column(
        children: List<Widget>.generate(cues.length, (index) {
          final cue = cues[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == cues.length - 1 ? 0 : AppSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${cue.breathIndex}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      cue.text.trim(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        height: 1.7,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _HighlightedSectionCard extends StatelessWidget {
  const _HighlightedSectionCard({
    required this.title,
    required this.icon,
    required this.accentBackground,
    required this.iconBackground,
    required this.iconColor,
    required this.body,
  });

  final String title;
  final IconData icon;
  final Color accentBackground;
  final Color iconBackground;
  final Color iconColor;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.7,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.76),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepEmptyState extends StatelessWidget {
  const _StepEmptyState({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(CupertinoIcons.pencil, size: 28, color: primary),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 큐잉 노트가 없어요\n편집 버튼을 눌러 작성해보세요',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: primary,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.pencil,
                      size: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '큐잉 노트 작성',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
