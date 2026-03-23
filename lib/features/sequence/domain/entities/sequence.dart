import '../enums/sequence_level.dart';

class Sequence {
  const Sequence({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.tags,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String? description;
  final SequenceLevel level;
  final List<String> tags;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
}
