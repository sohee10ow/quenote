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
import '../models/sequence_backup_snapshot.dart';

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

  Future<int> countSequences() async {
    final isar = await _db();
    return isar.isarSequenceModels.count();
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

  Future<StepDuplicationResult> duplicateStepIntoSameSequence(int stepId) async {
    final isar = await _db();
    final step = await _requireStep(isar, stepId);
    final copiedImagePaths = await _duplicateImagePaths(step.imagePaths);

    try {
      late int duplicatedStepId;
      await isar.writeTxn(() async {
        final steps = await isar.isarSequenceStepModels
            .filter()
            .sequenceIdEqualTo(step.sequenceId)
            .findAll();
        steps.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        for (final item in steps.where(
          (item) => item.orderIndex > step.orderIndex,
        )) {
          item.orderIndex += 1;
          await isar.isarSequenceStepModels.put(item);
        }

        final duplicatedStep = _buildDuplicatedStepModel(
          source: step,
          sequenceId: step.sequenceId,
          orderIndex: step.orderIndex + 1,
          imagePaths: copiedImagePaths,
        );

        duplicatedStepId = await isar.isarSequenceStepModels.put(
          duplicatedStep,
        );
        await _touchSequence(isar, step.sequenceId);
      });

      return StepDuplicationResult(
        targetSequenceId: step.sequenceId,
        newStepId: duplicatedStepId,
      );
    } catch (_) {
      await stepImageStorage.deleteFiles(copiedImagePaths);
      rethrow;
    }
  }

  Future<StepDuplicationResult> duplicateStepIntoSequence({
    required int stepId,
    required int targetSequenceId,
  }) async {
    final isar = await _db();
    final step = await _requireStep(isar, stepId);

    if (step.sequenceId == targetSequenceId) {
      return duplicateStepIntoSameSequence(stepId);
    }

    final targetSequence = await isar.isarSequenceModels.get(targetSequenceId);
    if (targetSequence == null) {
      throw StateError('대상 시퀀스를 찾을 수 없습니다.');
    }

    final copiedImagePaths = await _duplicateImagePaths(step.imagePaths);

    try {
      late int duplicatedStepId;
      await isar.writeTxn(() async {
        final duplicatedStep = _buildDuplicatedStepModel(
          source: step,
          sequenceId: targetSequenceId,
          orderIndex: await _nextOrderIndex(isar, targetSequenceId),
          imagePaths: copiedImagePaths,
        );

        duplicatedStepId = await isar.isarSequenceStepModels.put(
          duplicatedStep,
        );
        await _touchSequence(isar, targetSequenceId);
      });

      return StepDuplicationResult(
        targetSequenceId: targetSequenceId,
        newStepId: duplicatedStepId,
      );
    } catch (_) {
      await stepImageStorage.deleteFiles(copiedImagePaths);
      rethrow;
    }
  }

  Future<StepDuplicationResult> createSequenceAndDuplicateStep({
    required int sourceStepId,
    required String title,
    String? description,
    SequenceLevel level = SequenceLevel.beginner,
    List<String> tags = const <String>[],
  }) async {
    final isar = await _db();
    final step = await _requireStep(isar, sourceStepId);
    final copiedImagePaths = await _duplicateImagePaths(step.imagePaths);

    try {
      late int sequenceId;
      late int duplicatedStepId;
      await isar.writeTxn(() async {
        final now = DateTime.now();
        final sequence = IsarSequenceModel()
          ..title = title
          ..description = _nullIfEmpty(description)
          ..level = level.name
          ..tags = tags
              .where((tag) => tag.trim().isNotEmpty)
              .toList(growable: false)
          ..isFavorite = false
          ..createdAt = now
          ..updatedAt = now;

        sequenceId = await isar.isarSequenceModels.put(sequence);

        final duplicatedStep = _buildDuplicatedStepModel(
          source: step,
          sequenceId: sequenceId,
          orderIndex: 0,
          imagePaths: copiedImagePaths,
        );
        duplicatedStepId = await isar.isarSequenceStepModels.put(
          duplicatedStep,
        );
      });

      return StepDuplicationResult(
        targetSequenceId: sequenceId,
        newStepId: duplicatedStepId,
      );
    } catch (_) {
      await stepImageStorage.deleteFiles(copiedImagePaths);
      rethrow;
    }
  }

  Future<int> duplicateSequence(int sequenceId) async {
    final isar = await _db();
    final sequence = await isar.isarSequenceModels.get(sequenceId);
    if (sequence == null) {
      throw StateError('시퀀스를 찾을 수 없습니다.');
    }

    final steps = await isar.isarSequenceStepModels
        .filter()
        .sequenceIdEqualTo(sequenceId)
        .findAll();
    steps.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final duplicatedImagePaths = <String>[];
    final duplicatedStepImages = <int, List<String>>{};

    try {
      for (final step in steps) {
        final copied = await _duplicateImagePaths(step.imagePaths);
        duplicatedStepImages[step.id] = copied;
        duplicatedImagePaths.addAll(copied);
      }

      final now = DateTime.now();
      late int duplicatedSequenceId;

      await isar.writeTxn(() async {
        final duplicatedSequence = IsarSequenceModel()
          ..title = _duplicateTitle(sequence.title)
          ..description = sequence.description
          ..level = sequence.level
          ..tags = List<String>.from(sequence.tags)
          ..isFavorite = false
          ..createdAt = now
          ..updatedAt = now;

        duplicatedSequenceId = await isar.isarSequenceModels.put(
          duplicatedSequence,
        );

        for (final step in steps) {
          final duplicatedStep = IsarSequenceStepModel()
            ..sequenceId = duplicatedSequenceId
            ..orderIndex = step.orderIndex
            ..poseName = step.poseName
            ..sanskritName = step.sanskritName
            ..sideType = step.sideType
            ..isBalancePose = step.isBalancePose
            ..breathCount = step.breathCount
            ..preparationCue = step.preparationCue
            ..breathCues = _cloneBreathCues(step.breathCues)
            ..releaseCue = step.releaseCue
            ..cautionNote = step.cautionNote
            ..beginnerModificationNote = step.beginnerModificationNote
            ..imagePaths = duplicatedStepImages[step.id] ?? <String>[]
            ..createdAt = now
            ..updatedAt = now;
          await isar.isarSequenceStepModels.put(duplicatedStep);
        }
      });

      return duplicatedSequenceId;
    } catch (_) {
      await stepImageStorage.deleteFiles(duplicatedImagePaths);
      rethrow;
    }
  }

  Future<int> duplicateStep(int stepId) async {
    final result = await duplicateStepIntoSameSequence(stepId);
    return result.newStepId;
  }

  Future<void> replaceAllFromBackup(SequenceBackupSnapshot snapshot) async {
    final isar = await _db();
    final existingSteps = await isar.isarSequenceStepModels.where().findAll();
    final existingImagePaths = existingSteps
        .expand((step) => step.imagePaths)
        .toList(growable: false);

    await isar.writeTxn(() async {
      await isar.isarSequenceStepModels.clear();
      await isar.isarSequenceModels.clear();

      for (final sequence in snapshot.sequences) {
        final sequenceModel = IsarSequenceModel()
          ..title = sequence.title
          ..description = _nullIfEmpty(sequence.description)
          ..level = sequence.level
          ..tags = sequence.tags
          ..isFavorite = sequence.isFavorite
          ..createdAt = sequence.createdAt
          ..updatedAt = sequence.updatedAt;

        final sequenceId = await isar.isarSequenceModels.put(sequenceModel);

        final orderedSteps = List<SequenceBackupStep>.from(sequence.steps)
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        for (var index = 0; index < orderedSteps.length; index++) {
          final step = orderedSteps[index];
          final stepModel = IsarSequenceStepModel()
            ..sequenceId = sequenceId
            ..orderIndex = index
            ..poseName = step.poseName
            ..sanskritName = _nullIfEmpty(step.sanskritName)
            ..sideType = step.sideType
            ..isBalancePose = step.isBalancePose
            ..breathCount = step.breathCount
            ..preparationCue = step.preparationCue
            ..breathCues = step.breathCues
                .map(
                  (cue) => IsarBreathCueEntryModel(
                    breathIndex: cue.breathIndex,
                    text: cue.text,
                  ),
                )
                .toList(growable: false)
            ..releaseCue = step.releaseCue
            ..cautionNote = _nullIfEmpty(step.cautionNote)
            ..beginnerModificationNote = _nullIfEmpty(
              step.beginnerModificationNote,
            )
            ..imagePaths = <String>[]
            ..createdAt = step.createdAt
            ..updatedAt = step.updatedAt;
          await isar.isarSequenceStepModels.put(stepModel);
        }
      }
    });

    await stepImageStorage.deleteFiles(existingImagePaths);
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

  Future<List<String>> _duplicateImagePaths(List<String> imagePaths) async {
    final duplicated = <String>[];
    for (final path in imagePaths) {
      final copiedPath = await stepImageStorage.copyToAppStorageIfExists(path);
      if (copiedPath != null) {
        duplicated.add(copiedPath);
      }
    }
    return duplicated;
  }

  List<IsarBreathCueEntryModel> _cloneBreathCues(
    List<IsarBreathCueEntryModel> cues,
  ) {
    return cues
        .map(
          (cue) => IsarBreathCueEntryModel(
            breathIndex: cue.breathIndex,
            text: cue.text,
          ),
        )
        .toList(growable: false);
  }

  String _duplicateTitle(String value) {
    const duplicateSuffix = ' (복사본)';
    if (value.endsWith(duplicateSuffix)) {
      return value;
    }
    return '$value$duplicateSuffix';
  }

  Future<IsarSequenceStepModel> _requireStep(Isar isar, int stepId) async {
    final step = await isar.isarSequenceStepModels.get(stepId);
    if (step == null) {
      throw StateError('동작을 찾을 수 없습니다.');
    }
    return step;
  }

  IsarSequenceStepModel _buildDuplicatedStepModel({
    required IsarSequenceStepModel source,
    required int sequenceId,
    required int orderIndex,
    required List<String> imagePaths,
  }) {
    final now = DateTime.now();
    return IsarSequenceStepModel()
      ..sequenceId = sequenceId
      ..orderIndex = orderIndex
      ..poseName = source.poseName
      ..sanskritName = source.sanskritName
      ..sideType = source.sideType
      ..isBalancePose = source.isBalancePose
      ..breathCount = source.breathCount
      ..preparationCue = source.preparationCue
      ..breathCues = _cloneBreathCues(source.breathCues)
      ..releaseCue = source.releaseCue
      ..cautionNote = source.cautionNote
      ..beginnerModificationNote = source.beginnerModificationNote
      ..imagePaths = imagePaths
      ..createdAt = now
      ..updatedAt = now;
  }
}

class StepDuplicationResult {
  const StepDuplicationResult({
    required this.targetSequenceId,
    required this.newStepId,
  });

  final int targetSequenceId;
  final int newStepId;
}
