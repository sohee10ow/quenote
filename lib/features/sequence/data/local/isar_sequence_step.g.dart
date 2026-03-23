// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_sequence_step.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarSequenceStepModelCollection on Isar {
  IsarCollection<IsarSequenceStepModel> get isarSequenceStepModels =>
      this.collection();
}

const IsarSequenceStepModelSchema = CollectionSchema(
  name: r'IsarSequenceStepModel',
  id: 8334358962889777440,
  properties: {
    r'beginnerModificationNote': PropertySchema(
      id: 0,
      name: r'beginnerModificationNote',
      type: IsarType.string,
    ),
    r'breathCount': PropertySchema(
      id: 1,
      name: r'breathCount',
      type: IsarType.long,
    ),
    r'breathCues': PropertySchema(
      id: 2,
      name: r'breathCues',
      type: IsarType.objectList,
      target: r'IsarBreathCueEntryModel',
    ),
    r'cautionNote': PropertySchema(
      id: 3,
      name: r'cautionNote',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'imagePaths': PropertySchema(
      id: 5,
      name: r'imagePaths',
      type: IsarType.stringList,
    ),
    r'isBalancePose': PropertySchema(
      id: 6,
      name: r'isBalancePose',
      type: IsarType.bool,
    ),
    r'orderIndex': PropertySchema(
      id: 7,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'poseName': PropertySchema(
      id: 8,
      name: r'poseName',
      type: IsarType.string,
    ),
    r'preparationCue': PropertySchema(
      id: 9,
      name: r'preparationCue',
      type: IsarType.string,
    ),
    r'releaseCue': PropertySchema(
      id: 10,
      name: r'releaseCue',
      type: IsarType.string,
    ),
    r'sanskritName': PropertySchema(
      id: 11,
      name: r'sanskritName',
      type: IsarType.string,
    ),
    r'sequenceId': PropertySchema(
      id: 12,
      name: r'sequenceId',
      type: IsarType.long,
    ),
    r'sideType': PropertySchema(
      id: 13,
      name: r'sideType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarSequenceStepModelEstimateSize,
  serialize: _isarSequenceStepModelSerialize,
  deserialize: _isarSequenceStepModelDeserialize,
  deserializeProp: _isarSequenceStepModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'IsarBreathCueEntryModel': IsarBreathCueEntryModelSchema},
  getId: _isarSequenceStepModelGetId,
  getLinks: _isarSequenceStepModelGetLinks,
  attach: _isarSequenceStepModelAttach,
  version: '3.1.0+1',
);

int _isarSequenceStepModelEstimateSize(
  IsarSequenceStepModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.beginnerModificationNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.breathCues.length * 3;
  {
    final offsets = allOffsets[IsarBreathCueEntryModel]!;
    for (var i = 0; i < object.breathCues.length; i++) {
      final value = object.breathCues[i];
      bytesCount += IsarBreathCueEntryModelSchema.estimateSize(
          value, offsets, allOffsets);
    }
  }
  {
    final value = object.cautionNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imagePaths.length * 3;
  {
    for (var i = 0; i < object.imagePaths.length; i++) {
      final value = object.imagePaths[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.poseName.length * 3;
  bytesCount += 3 + object.preparationCue.length * 3;
  bytesCount += 3 + object.releaseCue.length * 3;
  {
    final value = object.sanskritName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sideType.length * 3;
  return bytesCount;
}

void _isarSequenceStepModelSerialize(
  IsarSequenceStepModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.beginnerModificationNote);
  writer.writeLong(offsets[1], object.breathCount);
  writer.writeObjectList<IsarBreathCueEntryModel>(
    offsets[2],
    allOffsets,
    IsarBreathCueEntryModelSchema.serialize,
    object.breathCues,
  );
  writer.writeString(offsets[3], object.cautionNote);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeStringList(offsets[5], object.imagePaths);
  writer.writeBool(offsets[6], object.isBalancePose);
  writer.writeLong(offsets[7], object.orderIndex);
  writer.writeString(offsets[8], object.poseName);
  writer.writeString(offsets[9], object.preparationCue);
  writer.writeString(offsets[10], object.releaseCue);
  writer.writeString(offsets[11], object.sanskritName);
  writer.writeLong(offsets[12], object.sequenceId);
  writer.writeString(offsets[13], object.sideType);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

IsarSequenceStepModel _isarSequenceStepModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarSequenceStepModel();
  object.beginnerModificationNote = reader.readStringOrNull(offsets[0]);
  object.breathCount = reader.readLong(offsets[1]);
  object.breathCues = reader.readObjectList<IsarBreathCueEntryModel>(
        offsets[2],
        IsarBreathCueEntryModelSchema.deserialize,
        allOffsets,
        IsarBreathCueEntryModel(),
      ) ??
      [];
  object.cautionNote = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.id = id;
  object.imagePaths = reader.readStringList(offsets[5]) ?? [];
  object.isBalancePose = reader.readBool(offsets[6]);
  object.orderIndex = reader.readLong(offsets[7]);
  object.poseName = reader.readString(offsets[8]);
  object.preparationCue = reader.readString(offsets[9]);
  object.releaseCue = reader.readString(offsets[10]);
  object.sanskritName = reader.readStringOrNull(offsets[11]);
  object.sequenceId = reader.readLong(offsets[12]);
  object.sideType = reader.readString(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _isarSequenceStepModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readObjectList<IsarBreathCueEntryModel>(
            offset,
            IsarBreathCueEntryModelSchema.deserialize,
            allOffsets,
            IsarBreathCueEntryModel(),
          ) ??
          []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarSequenceStepModelGetId(IsarSequenceStepModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarSequenceStepModelGetLinks(
    IsarSequenceStepModel object) {
  return [];
}

void _isarSequenceStepModelAttach(
    IsarCollection<dynamic> col, Id id, IsarSequenceStepModel object) {
  object.id = id;
}

extension IsarSequenceStepModelQueryWhereSort
    on QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QWhere> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarSequenceStepModelQueryWhere on QueryBuilder<IsarSequenceStepModel,
    IsarSequenceStepModel, QWhereClause> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarSequenceStepModelQueryFilter on QueryBuilder<
    IsarSequenceStepModel, IsarSequenceStepModel, QFilterCondition> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beginnerModificationNote',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beginnerModificationNote',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beginnerModificationNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      beginnerModificationNoteContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beginnerModificationNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      beginnerModificationNoteMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beginnerModificationNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beginnerModificationNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> beginnerModificationNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beginnerModificationNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breathCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breathCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breathCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breathCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> breathCuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'breathCues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cautionNote',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cautionNote',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cautionNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      cautionNoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cautionNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      cautionNoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cautionNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cautionNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> cautionNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cautionNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      imagePathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      imagePathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> imagePathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imagePaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> isBalancePoseEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBalancePose',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      poseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      poseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poseName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> poseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poseName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preparationCue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      preparationCueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preparationCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      preparationCueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preparationCue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preparationCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> preparationCueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preparationCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'releaseCue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      releaseCueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'releaseCue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      releaseCueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'releaseCue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> releaseCueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'releaseCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sanskritName',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sanskritName',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sanskritName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      sanskritNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sanskritName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      sanskritNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sanskritName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sanskritName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sanskritNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sanskritName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sequenceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sequenceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sequenceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sequenceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sideType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      sideTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sideType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      sideTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sideType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sideType',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> sideTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sideType',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarSequenceStepModelQueryObject on QueryBuilder<
    IsarSequenceStepModel, IsarSequenceStepModel, QFilterCondition> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel,
          QAfterFilterCondition>
      breathCuesElement(FilterQuery<IsarBreathCueEntryModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'breathCues');
    });
  }
}

extension IsarSequenceStepModelQueryLinks on QueryBuilder<IsarSequenceStepModel,
    IsarSequenceStepModel, QFilterCondition> {}

extension IsarSequenceStepModelQuerySortBy
    on QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QSortBy> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByBeginnerModificationNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByBeginnerModificationNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByBreathCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByCautionNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByCautionNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByIsBalancePoseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByPoseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByPoseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByPreparationCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByPreparationCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByReleaseCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByReleaseCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySanskritName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySanskritNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySequenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceId', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySequenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceId', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySideType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortBySideTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarSequenceStepModelQuerySortThenBy
    on QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QSortThenBy> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByBeginnerModificationNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByBeginnerModificationNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByBreathCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByCautionNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByCautionNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByIsBalancePoseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByPoseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByPoseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByPreparationCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByPreparationCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByReleaseCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByReleaseCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySanskritName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySanskritNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySequenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceId', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySequenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceId', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySideType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenBySideTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.desc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarSequenceStepModelQueryWhereDistinct
    on QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct> {
  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByBeginnerModificationNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beginnerModificationNote',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breathCount');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByCautionNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cautionNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByImagePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePaths');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBalancePose');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByPoseName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByPreparationCue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preparationCue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByReleaseCue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseCue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctBySanskritName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sanskritName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctBySequenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceId');
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctBySideType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sideType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSequenceStepModel, IsarSequenceStepModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarSequenceStepModelQueryProperty on QueryBuilder<
    IsarSequenceStepModel, IsarSequenceStepModel, QQueryProperty> {
  QueryBuilder<IsarSequenceStepModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String?, QQueryOperations>
      beginnerModificationNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beginnerModificationNote');
    });
  }

  QueryBuilder<IsarSequenceStepModel, int, QQueryOperations>
      breathCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathCount');
    });
  }

  QueryBuilder<IsarSequenceStepModel, List<IsarBreathCueEntryModel>,
      QQueryOperations> breathCuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathCues');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String?, QQueryOperations>
      cautionNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cautionNote');
    });
  }

  QueryBuilder<IsarSequenceStepModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarSequenceStepModel, List<String>, QQueryOperations>
      imagePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePaths');
    });
  }

  QueryBuilder<IsarSequenceStepModel, bool, QQueryOperations>
      isBalancePoseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBalancePose');
    });
  }

  QueryBuilder<IsarSequenceStepModel, int, QQueryOperations>
      orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String, QQueryOperations>
      poseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poseName');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String, QQueryOperations>
      preparationCueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preparationCue');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String, QQueryOperations>
      releaseCueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseCue');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String?, QQueryOperations>
      sanskritNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sanskritName');
    });
  }

  QueryBuilder<IsarSequenceStepModel, int, QQueryOperations>
      sequenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceId');
    });
  }

  QueryBuilder<IsarSequenceStepModel, String, QQueryOperations>
      sideTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sideType');
    });
  }

  QueryBuilder<IsarSequenceStepModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
