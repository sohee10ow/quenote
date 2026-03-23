import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/application/home_providers.dart';
import '../../application/sequence_providers.dart';
import '../../domain/entities/sequence.dart';
import '../../domain/entities/sequence_step.dart';
import '../../domain/enums/side_type.dart';
import '../args/sequence_route_args.dart';

class SequenceDetailScreen extends ConsumerStatefulWidget {
  const SequenceDetailScreen({super.key, required this.sequenceId});

  final int sequenceId;

  @override
  ConsumerState<SequenceDetailScreen> createState() =>
      _SequenceDetailScreenState();
}

class _SequenceDetailScreenState extends ConsumerState<SequenceDetailScreen> {
  bool _copySuccess = false;
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final sequenceAsync = ref.watch(sequenceByIdProvider(widget.sequenceId));
    final stepsAsync = ref.watch(sequenceStepsProvider(widget.sequenceId));
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

            if (sequence == null) {
              return const Center(child: Text('시퀀스를 찾을 수 없습니다.'));
            }

            if (steps == null) {
              return const Center(child: Text('불러오기에 실패했습니다.'));
            }

            return _buildContent(context, sequence, steps);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Sequence sequence,
    List<SequenceStep> steps,
  ) {
    final theme = Theme.of(context);
    final cueNoteCount = steps.where(_hasCueNote).length;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        _HeaderCard(
          sequence: sequence,
          stepCount: steps.length,
          cueNoteCount: cueNoteCount,
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: _copySuccess ? '복사됨' : '텍스트 복사',
                  icon: _copySuccess
                      ? CupertinoIcons.check_mark
                      : CupertinoIcons.doc_on_doc,
                  onTap: () =>
                      _copyShareText(context, _buildShareText(sequence, steps)),
                  isAccent: _copySuccess,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _ActionButton(
                  label: '공유',
                  icon: CupertinoIcons.share,
                  onTap: () => _openSharePreview(context, sequence, steps),
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ),
        if ((sequence.description ?? '').trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: _NoteCard(note: sequence.description!.trim()),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '동작 순서',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (steps.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.stepReorder,
                      arguments: StepReorderRouteArgs(
                        sequenceId: widget.sequenceId,
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    '순서 변경',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: steps.isEmpty
              ? _EmptyStepCard(onTap: () => _openAddStep(context))
              : _StepGroupCard(
                  steps: steps,
                  sideLabel: _sideLabel,
                  previewBuilder: _stepPreview,
                  onTapStep: (stepId) {
                    Navigator.of(context).pushNamed(
                      AppRoutes.stepDetail,
                      arguments: StepDetailRouteArgs(
                        sequenceId: widget.sequenceId,
                        stepId: stepId,
                      ),
                    );
                  },
                ),
        ),
        if (steps.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: _AddStepButton(onTap: () => _openAddStep(context)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: _DeleteButton(
            isBusy: _deleting,
            onTap: () => _confirmDelete(context, sequence),
          ),
        ),
      ],
    );
  }

  void _openAddStep(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.stepEditor,
      arguments: StepEditorRouteArgs(sequenceId: widget.sequenceId),
    );
  }

  Future<void> _copyShareText(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    await HapticFeedback.lightImpact();

    if (!mounted) {
      return;
    }

    setState(() => _copySuccess = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copySuccess = false);
      }
    });
  }

  Future<void> _openSharePreview(
    BuildContext context,
    Sequence sequence,
    List<SequenceStep> steps,
  ) async {
    final controller = TextEditingController(
      text: _buildShareText(sequence, steps),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SharePreviewBottomSheet(
          controller: controller,
          onCopy: () async {
            await Clipboard.setData(ClipboardData(text: controller.text));
            await HapticFeedback.lightImpact();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            if (mounted) {
              setState(() => _copySuccess = true);
              Future<void>.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() => _copySuccess = false);
                }
              });
            }
          },
        );
      },
    );

    controller.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, Sequence sequence) async {
    if (_deleting) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => _DeleteSequenceDialog(title: sequence.title),
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() => _deleting = true);

    try {
      await ref
          .read(sequenceRepositoryProvider)
          .deleteSequence(widget.sequenceId);
      ref.invalidate(sequenceByIdProvider(widget.sequenceId));
      ref.invalidate(sequenceStepsProvider(widget.sequenceId));
      ref.invalidate(sequenceListProvider);
      ref.invalidate(sequenceStepCountsProvider);
      ref.invalidate(favoriteSequenceListProvider);
      ref.invalidate(recentSequenceListProvider);
      ref.invalidate(homeOverviewProvider);

      await HapticFeedback.lightImpact();

      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(this.context);
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        navigator.pushReplacementNamed(AppRoutes.sequenceList);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFE89D91),
            content: Text('저장에 실패했습니다. 다시 시도해주세요.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }

  bool _hasCueNote(SequenceStep step) {
    return step.preparationCue.trim().isNotEmpty ||
        step.releaseCue.trim().isNotEmpty ||
        step.breathCues.any((cue) => cue.text.trim().isNotEmpty);
  }

  String _sideLabel(SideType sideType) {
    switch (sideType) {
      case SideType.left:
        return '왼쪽';
      case SideType.right:
        return '오른쪽';
      case SideType.both:
        return '좌/우 반복';
      case SideType.none:
        return '';
    }
  }

  String _stepPreview(SequenceStep step) {
    final parts = <String>[];
    if (step.preparationCue.trim().isNotEmpty) {
      parts.add(step.preparationCue.trim());
    }
    final firstBreath = step.breathCues
        .map((cue) => cue.text.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (firstBreath.isNotEmpty) {
      parts.add(firstBreath);
    }
    if (step.releaseCue.trim().isNotEmpty) {
      parts.add(step.releaseCue.trim());
    }
    if (parts.isEmpty) {
      return '큐잉이 아직 없습니다.';
    }
    return parts.join(' · ');
  }

  String _buildShareText(Sequence sequence, List<SequenceStep> steps) {
    final buffer = StringBuffer()..writeln(sequence.title);

    if (sequence.tags.isNotEmpty) {
      buffer.writeln(sequence.tags.join(' · '));
    }

    buffer.writeln();

    if ((sequence.description ?? '').trim().isNotEmpty) {
      buffer
        ..writeln('수업 노트')
        ..writeln(sequence.description!.trim())
        ..writeln();
    }

    for (var index = 0; index < steps.length; index++) {
      final step = steps[index];
      buffer.writeln('${index + 1}. ${step.poseName}');

      if (step.preparationCue.trim().isNotEmpty) {
        buffer.writeln('준비: ${step.preparationCue.trim()}');
      }

      for (final cue in step.breathCues) {
        final text = cue.text.trim();
        if (text.isEmpty) {
          continue;
        }
        buffer.writeln('${cue.breathIndex}호흡: $text');
      }

      if (step.releaseCue.trim().isNotEmpty) {
        buffer.writeln('마무리: ${step.releaseCue.trim()}');
      }

      if ((step.cautionNote ?? '').trim().isNotEmpty) {
        buffer.writeln('주의: ${step.cautionNote!.trim()}');
      }

      if ((step.beginnerModificationNote ?? '').trim().isNotEmpty) {
        buffer.writeln('초급자 수정: ${step.beginnerModificationNote!.trim()}');
      }

      buffer.writeln();
    }

    return buffer.toString().trimRight();
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.sequence,
    required this.stepCount,
    required this.cueNoteCount,
    required this.onBack,
  });

  final Sequence sequence;
  final int stepCount;
  final int cueNoteCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              children: [
                _CircleIconButton(icon: CupertinoIcons.back, onTap: onBack),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              sequence.title,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                height: 1.16,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _MetaChip(
                  icon: CupertinoIcons.flag,
                  label: _levelLabel(sequence.level.name),
                ),
                _MetaChip(
                  icon: CupertinoIcons.doc_text,
                  label: '$stepCount개 동작',
                ),
                if (cueNoteCount > 0)
                  _MetaChip(
                    icon: CupertinoIcons.chat_bubble_text,
                    label: '큐 노트 $cueNoteCount개',
                    isAccent: true,
                  ),
              ],
            ),
            if (sequence.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: sequence.tags
                    .map((tag) => _TagChip(label: tag))
                    .toList(growable: false),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _levelLabel(String name) {
    switch (name) {
      case 'advanced':
        return '상급';
      case 'intermediate':
        return '중급';
      case 'beginner':
      default:
        return '초급';
    }
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.tag, size: 12, color: primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    this.isAccent = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final background = isPrimary
        ? primary
        : isAccent
        ? primary.withValues(alpha: 0.1)
        : theme.cardColor;
    final foreground = isPrimary
        ? theme.colorScheme.onPrimary
        : isAccent
        ? primary
        : theme.colorScheme.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isPrimary ? 0.08 : 0.04),
            blurRadius: isPrimary ? 8 : 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
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
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    CupertinoIcons.doc_text,
                    size: 16,
                    color: primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '수업 노트',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.7,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStepCard extends StatelessWidget {
  const _EmptyStepCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
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
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
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
              child: Icon(CupertinoIcons.add, size: 30, color: primary),
            ),
            const SizedBox(height: 16),
            Text(
              '아직 동작이 없어요\n첫 번째 동작을 추가해보세요',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            _FilledPillButton(label: '동작 추가', onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _StepGroupCard extends StatelessWidget {
  const _StepGroupCard({
    required this.steps,
    required this.sideLabel,
    required this.previewBuilder,
    required this.onTapStep,
  });

  final List<SequenceStep> steps;
  final String Function(SideType sideType) sideLabel;
  final String Function(SequenceStep step) previewBuilder;
  final ValueChanged<int> onTapStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
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
      child: Column(
        children: List<Widget>.generate(steps.length, (index) {
          final step = steps[index];
          final preview = previewBuilder(step);
          return _StepRow(
            order: index + 1,
            poseName: step.poseName,
            preview: preview,
            sideLabel: sideLabel(step.sideType),
            hasCueNote: preview != '큐잉이 아직 없습니다.',
            isFirst: index == 0,
            onTap: () => onTapStep(step.id),
          );
        }),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.order,
    required this.poseName,
    required this.preview,
    required this.sideLabel,
    required this.hasCueNote,
    required this.isFirst,
    required this.onTap,
  });

  final int order;
  final String poseName;
  final String preview;
  final String sideLabel;
  final bool hasCueNote;
  final bool isFirst;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              top: isFirst
                  ? BorderSide.none
                  : BorderSide(
                      color:
                          theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.08,
                          ) ??
                          Colors.black12,
                    ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$order',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poseName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (sideLabel.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          sideLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (hasCueNote)
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble_text,
                            size: 14,
                            color: primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '큐 노트 없음',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddStepButton extends StatelessWidget {
  const _AddStepButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.add, size: 18, color: primary),
                const SizedBox(width: 8),
                Text(
                  '동작 추가',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.isBusy, required this.onTap});

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.error.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isBusy ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: isBusy
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.error,
                    ),
                  )
                : Text(
                    '시퀀스 삭제',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.error,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _DeleteSequenceDialog extends StatelessWidget {
  const _DeleteSequenceDialog({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시퀀스 삭제',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '\'$title\' 시퀀스를 삭제하시겠어요?\n이 작업은 되돌릴 수 없습니다.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: '취소',
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogButton(
                      label: '삭제',
                      onTap: () => Navigator.of(context).pop(true),
                      variant: _DialogButtonVariant.destructive,
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

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onTap,
    this.variant = _DialogButtonVariant.neutral,
  });

  final String label;
  final VoidCallback onTap;
  final _DialogButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = switch (variant) {
      _DialogButtonVariant.neutral => theme.scaffoldBackgroundColor,
      _DialogButtonVariant.primary => theme.colorScheme.primary,
      _DialogButtonVariant.destructive => theme.colorScheme.error,
    };
    final foreground = switch (variant) {
      _DialogButtonVariant.neutral => theme.colorScheme.onSurface,
      _DialogButtonVariant.primary => theme.colorScheme.onPrimary,
      _DialogButtonVariant.destructive => theme.colorScheme.onPrimary,
    };

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _DialogButtonVariant { neutral, primary, destructive }

class _FilledPillButton extends StatelessWidget {
  const _FilledPillButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.add,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
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
    );
  }
}

class _SharePreviewBottomSheet extends StatelessWidget {
  const _SharePreviewBottomSheet({
    required this.controller,
    required this.onCopy,
  });

  final TextEditingController controller;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '공유 미리보기',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 14,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.scaffoldBackgroundColor,
                  hintText: '공유할 내용을 확인하세요',
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: '닫기',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogButton(
                      label: '복사',
                      onTap: onCopy,
                      variant: _DialogButtonVariant.primary,
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
