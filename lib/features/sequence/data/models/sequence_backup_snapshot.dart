class SequenceBackupSnapshot {
  const SequenceBackupSnapshot({
    required this.schemaVersion,
    required this.exportedAt,
    required this.sequences,
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final List<SequenceBackupSequence> sequences;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'sequences': sequences.map((sequence) => sequence.toJson()).toList(),
    };
  }

  factory SequenceBackupSnapshot.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'];
    final exportedAt = json['exportedAt'];
    final sequences = json['sequences'];

    if (schemaVersion is! int || exportedAt is! String || sequences is! List) {
      throw const FormatException('백업 파일 형식이 올바르지 않습니다.');
    }

    return SequenceBackupSnapshot(
      schemaVersion: schemaVersion,
      exportedAt: DateTime.parse(exportedAt),
      sequences: sequences
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('시퀀스 데이터 형식이 올바르지 않습니다.');
            }
            return SequenceBackupSequence.fromJson(item);
          })
          .toList(growable: false),
    );
  }
}

class SequenceBackupSequence {
  const SequenceBackupSequence({
    required this.title,
    required this.description,
    required this.level,
    required this.tags,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.steps,
  });

  final String title;
  final String? description;
  final String level;
  final List<String> tags;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SequenceBackupStep> steps;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'level': level,
      'tags': tags,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }

  factory SequenceBackupSequence.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final description = json['description'];
    final level = json['level'];
    final tags = json['tags'];
    final isFavorite = json['isFavorite'];
    final createdAt = json['createdAt'];
    final updatedAt = json['updatedAt'];
    final steps = json['steps'];

    if (title is! String ||
        level is! String ||
        tags is! List ||
        isFavorite is! bool ||
        createdAt is! String ||
        updatedAt is! String ||
        steps is! List) {
      throw const FormatException('시퀀스 데이터가 올바르지 않습니다.');
    }

    return SequenceBackupSequence(
      title: title,
      description: description is String ? description : null,
      level: level,
      tags: tags.map((tag) => tag.toString()).toList(growable: false),
      isFavorite: isFavorite,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      steps: steps
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('동작 데이터 형식이 올바르지 않습니다.');
            }
            return SequenceBackupStep.fromJson(item);
          })
          .toList(growable: false),
    );
  }
}

class SequenceBackupStep {
  const SequenceBackupStep({
    required this.orderIndex,
    required this.poseName,
    required this.sanskritName,
    required this.sideType,
    required this.isBalancePose,
    required this.breathCount,
    required this.preparationCue,
    required this.breathCues,
    required this.releaseCue,
    required this.cautionNote,
    required this.beginnerModificationNote,
    required this.createdAt,
    required this.updatedAt,
  });

  final int orderIndex;
  final String poseName;
  final String? sanskritName;
  final String sideType;
  final bool isBalancePose;
  final int breathCount;
  final String preparationCue;
  final List<SequenceBackupBreathCue> breathCues;
  final String releaseCue;
  final String? cautionNote;
  final String? beginnerModificationNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'orderIndex': orderIndex,
      'poseName': poseName,
      'sanskritName': sanskritName,
      'sideType': sideType,
      'isBalancePose': isBalancePose,
      'breathCount': breathCount,
      'preparationCue': preparationCue,
      'breathCues': breathCues.map((cue) => cue.toJson()).toList(),
      'releaseCue': releaseCue,
      'cautionNote': cautionNote,
      'beginnerModificationNote': beginnerModificationNote,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SequenceBackupStep.fromJson(Map<String, dynamic> json) {
    final orderIndex = json['orderIndex'];
    final poseName = json['poseName'];
    final sanskritName = json['sanskritName'];
    final sideType = json['sideType'];
    final isBalancePose = json['isBalancePose'];
    final breathCount = json['breathCount'];
    final preparationCue = json['preparationCue'];
    final breathCues = json['breathCues'];
    final releaseCue = json['releaseCue'];
    final cautionNote = json['cautionNote'];
    final beginnerModificationNote = json['beginnerModificationNote'];
    final createdAt = json['createdAt'];
    final updatedAt = json['updatedAt'];

    if (orderIndex is! int ||
        poseName is! String ||
        sideType is! String ||
        isBalancePose is! bool ||
        breathCount is! int ||
        preparationCue is! String ||
        breathCues is! List ||
        releaseCue is! String ||
        createdAt is! String ||
        updatedAt is! String) {
      throw const FormatException('동작 데이터가 올바르지 않습니다.');
    }

    return SequenceBackupStep(
      orderIndex: orderIndex,
      poseName: poseName,
      sanskritName: sanskritName is String ? sanskritName : null,
      sideType: sideType,
      isBalancePose: isBalancePose,
      breathCount: breathCount,
      preparationCue: preparationCue,
      breathCues: breathCues
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('호흡 큐 데이터 형식이 올바르지 않습니다.');
            }
            return SequenceBackupBreathCue.fromJson(item);
          })
          .toList(growable: false),
      releaseCue: releaseCue,
      cautionNote: cautionNote is String ? cautionNote : null,
      beginnerModificationNote: beginnerModificationNote is String
          ? beginnerModificationNote
          : null,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

class SequenceBackupBreathCue {
  const SequenceBackupBreathCue({
    required this.breathIndex,
    required this.text,
  });

  final int breathIndex;
  final String text;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'breathIndex': breathIndex,
      'text': text,
    };
  }

  factory SequenceBackupBreathCue.fromJson(Map<String, dynamic> json) {
    final breathIndex = json['breathIndex'];
    final text = json['text'];

    if (breathIndex is! int || text is! String) {
      throw const FormatException('호흡 큐 데이터가 올바르지 않습니다.');
    }

    return SequenceBackupBreathCue(breathIndex: breathIndex, text: text);
  }
}
