import 'package:isar/isar.dart';

import '../../domain/entities/sequence.dart';
import '../../domain/enums/sequence_level.dart';

part 'isar_sequence.g.dart';

@collection
class IsarSequenceModel {
  IsarSequenceModel();

  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  String level = SequenceLevel.beginner.name;
  List<String> tags = <String>[];
  bool isFavorite = false;
  late DateTime createdAt;
  late DateTime updatedAt;
}

extension IsarSequenceMapper on IsarSequenceModel {
  Sequence toDomain() {
    return Sequence(
      id: id,
      title: title,
      description: description,
      level: SequenceLevel.values.firstWhere(
        (value) => value.name == level,
        orElse: () => SequenceLevel.beginner,
      ),
      tags: List<String>.from(tags),
      isFavorite: isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
