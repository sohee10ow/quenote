import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sequence/application/sequence_providers.dart';
import '../../sequence/domain/entities/sequence.dart';
import '../../sequence/domain/entities/sequence_step.dart';
import '../domain/entities/home_overview.dart';

final homeOverviewProvider = FutureProvider<HomeOverview>((ref) async {
  final repository = ref.watch(sequenceRepositoryProvider);
  final sequences = await repository.fetchSequences();
  final stepCounts = await repository.fetchStepCountsBySequence();
  final recentEditedSteps = await repository.fetchRecentlyEditedSteps(limit: 4);

  final sequenceTitleById = <int, String>{
    for (final sequence in sequences) sequence.id: sequence.title,
  };

  HomeSequenceSummary toSummary(Sequence sequence) {
    return HomeSequenceSummary(
      sequence: sequence,
      stepCount: stepCounts[sequence.id] ?? 0,
    );
  }

  final favoriteSequences = sequences
      .where((sequence) => sequence.isFavorite)
      .take(3)
      .map(toSummary)
      .toList(growable: false);

  final recentSequences = sequences
      .take(3)
      .map(toSummary)
      .toList(growable: false);

  final recentCueNotes = recentEditedSteps
      .where((step) => sequenceTitleById.containsKey(step.sequenceId))
      .map(
        (step) => HomeRecentCueNoteSummary(
          sequenceId: step.sequenceId,
          sequenceTitle: sequenceTitleById[step.sequenceId]!,
          stepId: step.id,
          stepOrder: step.orderIndex + 1,
          poseName: step.poseName,
          preview: _buildCuePreview(step),
        ),
      )
      .toList(growable: false);

  return HomeOverview(
    hasSequences: sequences.isNotEmpty,
    favoriteSequences: favoriteSequences,
    recentSequences: recentSequences,
    recentCueNotes: recentCueNotes,
  );
});

String? _buildCuePreview(SequenceStep step) {
  final candidates = <String>[
    step.preparationCue.trim(),
    ...step.breathCues.map((cue) => cue.text.trim()),
    step.releaseCue.trim(),
  ].where((text) => text.isNotEmpty);

  if (candidates.isEmpty) {
    return null;
  }

  return candidates.first;
}
