import 'package:isar/isar.dart';

import '../../domain/entities/breath_cue_entry.dart';
import '../../domain/entities/sequence_step.dart';
import '../../domain/enums/side_type.dart';
import 'isar_breath_cue_entry.dart';

part 'isar_sequence_step.g.dart';

@collection
class IsarSequenceStepModel {
  IsarSequenceStepModel();

  Id id = Isar.autoIncrement;
  late int sequenceId;
  late int orderIndex;
  late String poseName;
  String? sanskritName;
  String sideType = SideType.none.name;
  bool isBalancePose = false;
  late int breathCount;
  String preparationCue = '';
  List<IsarBreathCueEntryModel> breathCues = <IsarBreathCueEntryModel>[];
  String releaseCue = '';
  String? cautionNote;
  String? beginnerModificationNote;
  List<String> imagePaths = <String>[];
  late DateTime createdAt;
  late DateTime updatedAt;
}

extension IsarSequenceStepMapper on IsarSequenceStepModel {
  SequenceStep toDomain() {
    return SequenceStep(
      id: id,
      sequenceId: sequenceId,
      orderIndex: orderIndex,
      poseName: poseName,
      sanskritName: sanskritName,
      sideType: SideType.values.firstWhere(
        (value) => value.name == sideType,
        orElse: () => SideType.none,
      ),
      isBalancePose: isBalancePose,
      breathCount: breathCount,
      preparationCue: preparationCue,
      breathCues: breathCues
          .map(
            (cue) =>
                BreathCueEntry(breathIndex: cue.breathIndex, text: cue.text),
          )
          .toList(growable: false),
      releaseCue: releaseCue,
      cautionNote: cautionNote,
      beginnerModificationNote: beginnerModificationNote,
      imagePaths: List<String>.from(imagePaths),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
