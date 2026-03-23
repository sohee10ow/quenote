import 'package:isar/isar.dart';

part 'isar_breath_cue_entry.g.dart';

@embedded
class IsarBreathCueEntryModel {
  IsarBreathCueEntryModel({this.breathIndex = 1, this.text = ''});

  int breathIndex;
  String text;
}
