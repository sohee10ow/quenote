import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/init/app_startup_controller.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../application/sequence_providers.dart';
import '../../application/sequence_share_text_builder.dart';
import '../../domain/entities/sequence.dart';
import '../../domain/entities/sequence_step.dart';
import '../../domain/enums/side_type.dart';

class SequenceFullViewScreen extends ConsumerWidget {
  const SequenceFullViewScreen({super.key, required this.sequenceId});

  final int sequenceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequenceAsync = ref.watch(sequenceByIdProvider(sequenceId));
    final stepsAsync = ref.watch(sequenceStepsProvider(sequenceId));
    final shareFormat = ref.watch(appShareFormatProvider);
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
            if (sequence == null || steps == null) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 14),
              );
            }

            final shareText = buildSequenceShareText(
              sequence,
              steps,
              shareFormat,
            );

            return Column(
              children: [
                _Header(sequence: sequence),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 132),
                    children: [
                      if ((sequence.description ?? '').trim().isNotEmpty) ...[
                        _SectionCard(
                          title: '수업 노트',
                          child: Text(
                            sequence.description!.trim(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      ...List<Widget>.generate(steps.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == steps.length - 1
                                ? 0
                                : AppSpacing.md,
                          ),
                          child: _StepCard(
                            order: index + 1,
                            step: steps[index],
                            sideLabel: _sideLabel(steps[index].sideType),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                _ActionBar(
                  onCopy: () async {
                    await Clipboard.setData(ClipboardData(text: shareText));
                    await HapticFeedback.lightImpact();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('전체 텍스트를 복사했어요.')),
                      );
                    }
                  },
                  onShare: () => Share.share(shareText),
                ),
              ],
            );
          },
        ),
      ),
    );
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
}

class _Header extends StatelessWidget {
  const _Header({required this.sequence});

  final Sequence sequence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levelLabel = switch (sequence.level.name) {
      'advanced' => '상급',
      'intermediate' => '중급',
      _ => '초급',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(CupertinoIcons.back),
              ),
              Expanded(
                child: Text(
                  '시퀀스 전체 보기',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sequence.title,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(label: levelLabel),
              _MetaChip(label: '${sequence.tags.length}개 태그'),
              ...sequence.tags.map((tag) => _MetaChip(label: tag)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: theme.textTheme.bodySmall),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.order,
    required this.step,
    required this.sideLabel,
  });

  final int order;
  final SequenceStep step;
  final String sideLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '$order. ${step.poseName}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _MetaChip(label: '${step.breathCount}호흡'),
              if (sideLabel.isNotEmpty) _MetaChip(label: sideLabel),
            ],
          ),
          if (step.preparationCue.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _StepSection(title: '준비동작 큐잉', content: step.preparationCue.trim()),
          ],
          if (step.breathCues.any((cue) => cue.text.trim().isNotEmpty)) ...[
            const SizedBox(height: 16),
            _StepSection(
              title: '호흡 큐잉',
              content: step.breathCues
                  .where((cue) => cue.text.trim().isNotEmpty)
                  .map((cue) => '${cue.breathIndex}호흡  ${cue.text.trim()}')
                  .join('\n'),
            ),
          ],
          if (step.releaseCue.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _StepSection(title: '동작 푸는 큐잉', content: step.releaseCue.trim()),
          ],
          if ((step.cautionNote ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _StepSection(title: '주의사항', content: step.cautionNote!.trim()),
          ],
          if ((step.beginnerModificationNote ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _StepSection(
              title: '초보자 변형 동작',
              content: step.beginnerModificationNote!.trim(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StepSection extends StatelessWidget {
  const _StepSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onCopy, required this.onShare});

  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.98),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCopy,
                icon: const Icon(CupertinoIcons.doc_on_doc),
                label: const Text('텍스트 복사'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onShare,
                icon: const Icon(CupertinoIcons.share),
                label: const Text('공유'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
