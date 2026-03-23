import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/entities/sequence.dart';
import '../../domain/entities/sequence_step.dart';
import '../../domain/enums/sequence_level.dart';
import '../../domain/enums/side_type.dart';
import '../local/isar_breath_cue_entry.dart';
import '../local/isar_sequence.dart';
import '../local/isar_sequence_step.dart';
import '../local/step_image_storage.dart';

class SequenceRepository {
  const SequenceRepository(this._read);

  final T Function<T>(ProviderListenable<T>) _read;

  Future<Isar> _db() => _read(isarProvider.future);

  Future<List<Sequence>> fetchSequences() async {
    final isar = await _db();
    final items = await isar.isarSequenceModels.where().findAll();
    final mapped = items.map((item) => item.toDomain()).toList(growable: false);
    mapped.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return mapped;
  }

  Future<List<Sequence>> fetchFavoriteSequences() async {
    final isar = await _db();
    final items = await isar.isarSequenceModels
        .filter()
        .isFavoriteEqualTo(true)
        .findAll();
    final mapped = items.map((item) => item.toDomain()).toList(growable: false);
    mapped.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return mapped;
  }

  Future<List<Sequence>> fetchRecentSequences({int limit = 5}) async {
    final all = await fetchSequences();
    if (all.length <= limit) {
      return all;
    }
    return all.sublist(0, limit);
  }

  Future<Map<int, int>> fetchStepCountsBySequence() async {
    final isar = await _db();
    final items = await isar.isarSequenceStepModels.where().findAll();
    final counts = <int, int>{};

    for (final item in items) {
      counts.update(item.sequenceId, (value) => value + 1, ifAbsent: () => 1);
    }

    return counts;
  }

  Future<Sequence?> findSequenceById(int id) async {
    final isar = await _db();
    final model = await isar.isarSequenceModels.get(id);
    return model?.toDomain();
  }

  Future<List<SequenceStep>> fetchStepsBySequence(int sequenceId) async {
    final isar = await _db();
    final items = await isar.isarSequenceStepModels
        .filter()
        .sequenceIdEqualTo(sequenceId)
        .findAll();
    final mapped = items.map((item) => item.toDomain()).toList(growable: false);
    mapped.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return mapped;
  }

  Future<SequenceStep?> findStepById(int stepId) async {
    final isar = await _db();
    final model = await isar.isarSequenceStepModels.get(stepId);
    return model?.toDomain();
  }

  Future<List<SequenceStep>> fetchRecentlyEditedSteps({int limit = 4}) async {
    final isar = await _db();
    final items = await isar.isarSequenceStepModels.where().findAll();
    final mapped = items.map((item) => item.toDomain()).toList();
    mapped.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (mapped.length <= limit) {
      return mapped;
    }
    return mapped.sublist(0, limit);
  }

  Future<int> createSequence({
    required String title,
    String? description,
    SequenceLevel level = SequenceLevel.beginner,
    List<String> tags = const <String>[],
  }) async {
    final isar = await _db();
    final now = DateTime.now();
    final model = IsarSequenceModel()
      ..title = title
      ..description = _nullIfEmpty(description)
      ..level = level.name
      ..tags = tags
          .where((tag) => tag.trim().isNotEmpty)
          .toList(growable: false)
      ..isFavorite = false
      ..createdAt = now
      ..updatedAt = now;

    return isar.writeTxn(() => isar.isarSequenceModels.put(model));
  }

  Future<void> toggleFavorite(int sequenceId) async {
    final isar = await _db();
    final model = await isar.isarSequenceModels.get(sequenceId);
    if (model == null) {
      return;
    }

    await isar.writeTxn(() async {
      model
        ..isFavorite = !model.isFavorite
        ..updatedAt = DateTime.now();
      await isar.isarSequenceModels.put(model);
    });
  }

  Future<void> deleteSequence(int sequenceId) async {
    final isar = await _db();
    final steps = await isar.isarSequenceStepModels
        .filter()
        .sequenceIdEqualTo(sequenceId)
        .findAll();
    final imagePaths = steps
        .expand((step) => step.imagePaths)
        .toList(growable: false);

    await isar.writeTxn(() async {
      for (final step in steps) {
        await isar.isarSequenceStepModels.delete(step.id);
      }

      await isar.isarSequenceModels.delete(sequenceId);
    });

    await stepImageStorage.deleteFiles(imagePaths);
  }

  Future<void> upsertStep({
    required int sequenceId,
    int? stepId,
    required String poseName,
    required String? sanskritName,
    required SideType sideType,
    required bool isBalancePose,
    required int breathCount,
    required String preparationCue,
    required List<String> breathCues,
    required String releaseCue,
    required String? cautionNote,
    required String? beginnerModificationNote,
    required List<String> imagePaths,
  }) async {
    final isar = await _db();
    final now = DateTime.now();
    final removedImagePaths = <String>[];

    await isar.writeTxn(() async {
      final model = stepId == null
          ? IsarSequenceStepModel()
          : (await isar.isarSequenceStepModels.get(stepId) ??
                IsarSequenceStepModel());

      if (stepId != null) {
        removedImagePaths.addAll(
          model.imagePaths.where((path) => !imagePaths.contains(path)),
        );
      }

      final nextOrder = stepId == null
          ? await _nextOrderIndex(isar, sequenceId)
          : model.orderIndex;

      model
        ..sequenceId = sequenceId
        ..orderIndex = nextOrder
        ..poseName = poseName
        ..sanskritName = _nullIfEmpty(sanskritName)
        ..sideType = sideType.name
        ..isBalancePose = isBalancePose
        ..breathCount = breathCount
        ..preparationCue = preparationCue
        ..breathCues = _toEmbeddedBreathCues(breathCues, breathCount)
        ..releaseCue = releaseCue
        ..cautionNote = _nullIfEmpty(cautionNote)
        ..beginnerModificationNote = _nullIfEmpty(beginnerModificationNote)
        ..imagePaths = imagePaths
            .where((path) => path.trim().isNotEmpty)
            .toList(growable: false)
        ..createdAt = stepId == null ? now : model.createdAt
        ..updatedAt = now;

      await isar.isarSequenceStepModels.put(model);
      await _touchSequence(isar, sequenceId);
    });

    await stepImageStorage.deleteFiles(removedImagePaths);
  }

  Future<void> deleteStep(int stepId) async {
    final isar = await _db();
    final model = await isar.isarSequenceStepModels.get(stepId);
    if (model == null) {
      return;
    }

    final imagePaths = List<String>.from(model.imagePaths);

    await isar.writeTxn(() async {
      await isar.isarSequenceStepModels.delete(stepId);
      await _normalizeOrderIndexes(isar, model.sequenceId);
      await _touchSequence(isar, model.sequenceId);
    });

    await stepImageStorage.deleteFiles(imagePaths);
  }

  Future<void> reorderSteps({
    required int sequenceId,
    required List<int> orderedStepIds,
  }) async {
    final isar = await _db();
    await isar.writeTxn(() async {
      for (var i = 0; i < orderedStepIds.length; i++) {
        final model = await isar.isarSequenceStepModels.get(orderedStepIds[i]);
        if (model == null) {
          continue;
        }
        model.orderIndex = i;
        await isar.isarSequenceStepModels.put(model);
      }
      await _touchSequence(isar, sequenceId);
    });
  }

  Future<int> _nextOrderIndex(Isar isar, int sequenceId) async {
    final steps = await isar.isarSequenceStepModels
        .filter()
        .sequenceIdEqualTo(sequenceId)
        .findAll();
    if (steps.isEmpty) {
      return 0;
    }
    final max = steps
        .map((step) => step.orderIndex)
        .reduce((current, next) => current > next ? current : next);
    return max + 1;
  }

  Future<void> _normalizeOrderIndexes(Isar isar, int sequenceId) async {
    final steps = await isar.isarSequenceStepModels
        .filter()
        .sequenceIdEqualTo(sequenceId)
        .findAll();
    steps.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (var i = 0; i < steps.length; i++) {
      steps[i].orderIndex = i;
      await isar.isarSequenceStepModels.put(steps[i]);
    }
  }

  Future<void> _touchSequence(Isar isar, int sequenceId) async {
    final sequence = await isar.isarSequenceModels.get(sequenceId);
    if (sequence == null) {
      return;
    }
    sequence.updatedAt = DateTime.now();
    await isar.isarSequenceModels.put(sequence);
  }

  List<IsarBreathCueEntryModel> _toEmbeddedBreathCues(
    List<String> breathCues,
    int breathCount,
  ) {
    final normalized = List<String>.generate(
      breathCount,
      (index) => index < breathCues.length ? breathCues[index] : '',
      growable: false,
    );

    return normalized
        .asMap()
        .entries
        .map(
          (entry) => IsarBreathCueEntryModel(
            breathIndex: entry.key + 1,
            text: entry.value,
          ),
        )
        .toList(growable: false);
  }

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
