import '../enums/side_type.dart';
import '../enums/step_template_category.dart';
import 'breath_cue_entry.dart';

class StepTemplate {
  const StepTemplate({
    required this.id,
    required this.category,
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
    required this.imagePaths,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final StepTemplateCategory category;
  final String poseName;
  final String? sanskritName;
  final SideType sideType;
  final bool isBalancePose;
  final int breathCount;
  final String preparationCue;
  final List<BreathCueEntry> breathCues;
  final String releaseCue;
  final String? cautionNote;
  final String? beginnerModificationNote;
  final List<String> imagePaths;
  final DateTime createdAt;
  final DateTime updatedAt;
}
