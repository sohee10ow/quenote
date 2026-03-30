import 'package:isar/isar.dart';

import '../../domain/entities/breath_cue_entry.dart';
import '../../domain/entities/step_template.dart';
import '../../domain/enums/side_type.dart';
import '../../domain/enums/step_template_category.dart';
import 'isar_breath_cue_entry.dart';

part 'isar_step_template.g.dart';

@collection
class IsarStepTemplateModel {
  IsarStepTemplateModel();

  Id id = Isar.autoIncrement;
  String category = StepTemplateCategory.repeating.name;
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

extension IsarStepTemplateMapper on IsarStepTemplateModel {
  StepTemplate toDomain() {
    return StepTemplate(
      id: id,
      category: StepTemplateCategory.values.firstWhere(
        (value) => value.name == category,
        orElse: () => StepTemplateCategory.repeating,
      ),
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
