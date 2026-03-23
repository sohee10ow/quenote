import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/sequence_repository.dart';
import '../domain/entities/sequence.dart';
import '../domain/entities/sequence_step.dart';

final sequenceRepositoryProvider = Provider<SequenceRepository>(
  (ref) => SequenceRepository(ref.read),
);

final sequenceListProvider = FutureProvider<List<Sequence>>(
  (ref) => ref.watch(sequenceRepositoryProvider).fetchSequences(),
);

final sequenceStepCountsProvider = FutureProvider<Map<int, int>>(
  (ref) => ref.watch(sequenceRepositoryProvider).fetchStepCountsBySequence(),
);

final favoriteSequenceListProvider = FutureProvider<List<Sequence>>(
  (ref) => ref.watch(sequenceRepositoryProvider).fetchFavoriteSequences(),
);

final recentSequenceListProvider = FutureProvider<List<Sequence>>(
  (ref) => ref.watch(sequenceRepositoryProvider).fetchRecentSequences(),
);

final sequenceByIdProvider = FutureProvider.family<Sequence?, int>(
  (ref, sequenceId) =>
      ref.watch(sequenceRepositoryProvider).findSequenceById(sequenceId),
);

final sequenceStepsProvider = FutureProvider.family<List<SequenceStep>, int>(
  (ref, sequenceId) =>
      ref.watch(sequenceRepositoryProvider).fetchStepsBySequence(sequenceId),
);

final stepByIdProvider = FutureProvider.family<SequenceStep?, int>(
  (ref, stepId) => ref.watch(sequenceRepositoryProvider).findStepById(stepId),
);
