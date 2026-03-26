import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/sequence_providers.dart';
import '../../domain/entities/sequence.dart';
import '../../domain/entities/sequence_step.dart';
import '../models/sequence_backup_snapshot.dart';

const _backupSchemaVersion = 1;

final sequenceBackupServiceProvider = Provider<SequenceBackupService>(
  (ref) => SequenceBackupService(ref.read),
);

class SequenceBackupService {
  const SequenceBackupService(this._read);

  final T Function<T>(ProviderListenable<T>) _read;

  Future<int> exportBackup() async {
    final snapshot = await _buildSnapshot();
    final file = await _writeSnapshot(snapshot);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Quenote 백업 파일',
      subject: 'Quenote 백업',
    );
    return snapshot.sequences.length;
  }

  Future<int?> restoreBackupFromPicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    String? jsonString;

    if (file.path != null) {
      jsonString = await File(file.path!).readAsString();
    } else if (file.bytes != null) {
      jsonString = utf8.decode(file.bytes!);
    }

    if (jsonString == null || jsonString.trim().isEmpty) {
      throw const FormatException('백업 파일이 비어 있습니다.');
    }

    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('백업 파일 형식이 올바르지 않습니다.');
    }

    final snapshot = SequenceBackupSnapshot.fromJson(decoded);
    if (snapshot.schemaVersion != _backupSchemaVersion) {
      throw const FormatException('지원하지 않는 백업 파일 버전입니다.');
    }

    await _read(sequenceRepositoryProvider).replaceAllFromBackup(snapshot);
    return snapshot.sequences.length;
  }

  Future<SequenceBackupSnapshot> _buildSnapshot() async {
    final repository = _read(sequenceRepositoryProvider);
    final sequences = await repository.fetchSequences();
    final backupSequences = <SequenceBackupSequence>[];

    for (final sequence in sequences) {
      final steps = await repository.fetchStepsBySequence(sequence.id);
      backupSequences.add(_toBackupSequence(sequence, steps));
    }

    return SequenceBackupSnapshot(
      schemaVersion: _backupSchemaVersion,
      exportedAt: DateTime.now(),
      sequences: backupSequences,
    );
  }

  SequenceBackupSequence _toBackupSequence(
    Sequence sequence,
    List<SequenceStep> steps,
  ) {
    return SequenceBackupSequence(
      title: sequence.title,
      description: sequence.description,
      level: sequence.level.name,
      tags: List<String>.from(sequence.tags),
      isFavorite: sequence.isFavorite,
      createdAt: sequence.createdAt,
      updatedAt: sequence.updatedAt,
      steps: steps
          .map(
            (step) => SequenceBackupStep(
              orderIndex: step.orderIndex,
              poseName: step.poseName,
              sanskritName: step.sanskritName,
              sideType: step.sideType.name,
              isBalancePose: step.isBalancePose,
              breathCount: step.breathCount,
              preparationCue: step.preparationCue,
              breathCues: step.breathCues
                  .map(
                    (cue) => SequenceBackupBreathCue(
                      breathIndex: cue.breathIndex,
                      text: cue.text,
                    ),
                  )
                  .toList(growable: false),
              releaseCue: step.releaseCue,
              cautionNote: step.cautionNote,
              beginnerModificationNote: step.beginnerModificationNote,
              createdAt: step.createdAt,
              updatedAt: step.updatedAt,
            ),
          )
          .toList(growable: false),
    );
  }

  Future<File> _writeSnapshot(SequenceBackupSnapshot snapshot) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/quenote-backup-$timestamp.json');
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(snapshot.toJson()));
    return file;
  }
}
