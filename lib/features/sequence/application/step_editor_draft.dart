import '../domain/enums/side_type.dart';

class StepEditorDraft {
  const StepEditorDraft({
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
  });

  final String poseName;
  final String sanskritName;
  final SideType sideType;
  final bool isBalancePose;
  final int breathCount;
  final String preparationCue;
  final List<String> breathCues;
  final String releaseCue;
  final String cautionNote;
  final String beginnerModificationNote;
  final List<String> imagePaths;

  factory StepEditorDraft.initial() {
    return const StepEditorDraft(
      poseName: '',
      sanskritName: '',
      sideType: SideType.none,
      isBalancePose: false,
      breathCount: 3,
      preparationCue: '',
      breathCues: <String>['', '', ''],
      releaseCue: '',
      cautionNote: '',
      beginnerModificationNote: '',
      imagePaths: <String>[],
    );
  }
}
