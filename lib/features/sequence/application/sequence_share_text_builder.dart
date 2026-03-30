import '../../settings/domain/enums/share_format_type.dart';
import '../domain/entities/sequence.dart';
import '../domain/entities/sequence_step.dart';

String buildSequenceShareText(
  Sequence sequence,
  List<SequenceStep> steps,
  ShareFormatType format,
) {
  switch (format) {
    case ShareFormatType.full:
      return buildFullSequenceShareText(sequence, steps);
    case ShareFormatType.cues:
      return _buildCueShareText(sequence, steps);
    case ShareFormatType.short:
      return _buildShortShareText(sequence, steps);
  }
}

String buildFullSequenceShareText(Sequence sequence, List<SequenceStep> steps) {
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

String _buildCueShareText(Sequence sequence, List<SequenceStep> steps) {
  final buffer = StringBuffer()
    ..writeln(sequence.title)
    ..writeln();

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

    buffer.writeln();
  }

  return buffer.toString().trimRight();
}

String _buildShortShareText(Sequence sequence, List<SequenceStep> steps) {
  final buffer = StringBuffer()
    ..writeln(sequence.title)
    ..writeln('${steps.length}개 동작');

  for (var index = 0; index < steps.length; index++) {
    buffer.writeln('${index + 1}. ${steps[index].poseName}');
  }

  return buffer.toString().trimRight();
}
