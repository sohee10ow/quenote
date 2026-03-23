import '../../../sequence/domain/entities/sequence.dart';

class HomeOverview {
  const HomeOverview({
    required this.hasSequences,
    required this.favoriteSequences,
    required this.recentSequences,
    required this.recentCueNotes,
  });

  final bool hasSequences;
  final List<HomeSequenceSummary> favoriteSequences;
  final List<HomeSequenceSummary> recentSequences;
  final List<HomeRecentCueNoteSummary> recentCueNotes;
}

class HomeSequenceSummary {
  const HomeSequenceSummary({required this.sequence, required this.stepCount});

  final Sequence sequence;
  final int stepCount;
}

class HomeRecentCueNoteSummary {
  const HomeRecentCueNoteSummary({
    required this.sequenceId,
    required this.sequenceTitle,
    required this.stepId,
    required this.stepOrder,
    required this.poseName,
    required this.preview,
  });

  final int sequenceId;
  final String sequenceTitle;
  final int stepId;
  final int stepOrder;
  final String poseName;
  final String? preview;
}
