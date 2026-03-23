import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/sequence.dart';

class SequenceMetadataSection extends StatelessWidget {
  const SequenceMetadataSection({
    super.key,
    required this.sequence,
    required this.stepCount,
  });

  final Sequence sequence;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('난이도: ${_levelLabel(sequence.level.name)}'),
          const SizedBox(height: AppSpacing.xs),
          Text('동작 수: $stepCount개'),
          if (sequence.description?.isNotEmpty ?? false) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(sequence.description!),
          ],
          if (sequence.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: sequence.tags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }

  String _levelLabel(String name) {
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
