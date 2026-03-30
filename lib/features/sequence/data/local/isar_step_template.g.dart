// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_step_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarStepTemplateModelCollection on Isar {
  IsarCollection<IsarStepTemplateModel> get isarStepTemplateModels =>
      this.collection();
}

const IsarStepTemplateModelSchema = CollectionSchema(
  name: r'IsarStepTemplateModel',
  id: -5229947020274922447,
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
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'cautionNote': PropertySchema(
      id: 4,
      name: r'cautionNote',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'imagePaths': PropertySchema(
      id: 6,
      name: r'imagePaths',
      type: IsarType.stringList,
    ),
    r'isBalancePose': PropertySchema(
      id: 7,
      name: r'isBalancePose',
      type: IsarType.bool,
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
    r'sideType': PropertySchema(
      id: 12,
      name: r'sideType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarStepTemplateModelEstimateSize,
  serialize: _isarStepTemplateModelSerialize,
  deserialize: _isarStepTemplateModelDeserialize,
  deserializeProp: _isarStepTemplateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'IsarBreathCueEntryModel': IsarBreathCueEntryModelSchema},
  getId: _isarStepTemplateModelGetId,
  getLinks: _isarStepTemplateModelGetLinks,
  attach: _isarStepTemplateModelAttach,
  version: '3.1.0+1',
);

int _isarStepTemplateModelEstimateSize(
  IsarStepTemplateModel object,
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
  bytesCount += 3 + object.category.length * 3;
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

void _isarStepTemplateModelSerialize(
  IsarStepTemplateModel object,
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
  writer.writeString(offsets[3], object.category);
  writer.writeString(offsets[4], object.cautionNote);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeStringList(offsets[6], object.imagePaths);
  writer.writeBool(offsets[7], object.isBalancePose);
  writer.writeString(offsets[8], object.poseName);
  writer.writeString(offsets[9], object.preparationCue);
  writer.writeString(offsets[10], object.releaseCue);
  writer.writeString(offsets[11], object.sanskritName);
  writer.writeString(offsets[12], object.sideType);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

IsarStepTemplateModel _isarStepTemplateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarStepTemplateModel();
  object.beginnerModificationNote = reader.readStringOrNull(offsets[0]);
  object.breathCount = reader.readLong(offsets[1]);
  object.breathCues = reader.readObjectList<IsarBreathCueEntryModel>(
        offsets[2],
        IsarBreathCueEntryModelSchema.deserialize,
        allOffsets,
        IsarBreathCueEntryModel(),
      ) ??
      [];
  object.category = reader.readString(offsets[3]);
  object.cautionNote = reader.readStringOrNull(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.id = id;
  object.imagePaths = reader.readStringList(offsets[6]) ?? [];
  object.isBalancePose = reader.readBool(offsets[7]);
  object.poseName = reader.readString(offsets[8]);
  object.preparationCue = reader.readString(offsets[9]);
  object.releaseCue = reader.readString(offsets[10]);
  object.sanskritName = reader.readStringOrNull(offsets[11]);
  object.sideType = reader.readString(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  return object;
}

P _isarStepTemplateModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarStepTemplateModelGetId(IsarStepTemplateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarStepTemplateModelGetLinks(
    IsarStepTemplateModel object) {
  return [];
}

void _isarStepTemplateModelAttach(
    IsarCollection<dynamic> col, Id id, IsarStepTemplateModel object) {
  object.id = id;
}

extension IsarStepTemplateModelQueryWhereSort
    on QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QWhere> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarStepTemplateModelQueryWhere on QueryBuilder<IsarStepTemplateModel,
    IsarStepTemplateModel, QWhereClause> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhereClause>
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterWhereClause>
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

extension IsarStepTemplateModelQueryFilter on QueryBuilder<
    IsarStepTemplateModel, IsarStepTemplateModel, QFilterCondition> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> beginnerModificationNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beginnerModificationNote',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> beginnerModificationNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beginnerModificationNote',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> beginnerModificationNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beginnerModificationNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> beginnerModificationNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beginnerModificationNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> breathCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breathCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> cautionNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cautionNote',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> cautionNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cautionNote',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> cautionNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cautionNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> cautionNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cautionNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> imagePathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> imagePathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> isBalancePoseEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBalancePose',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> poseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poseName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> poseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poseName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> preparationCueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preparationCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> preparationCueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preparationCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> releaseCueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'releaseCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> releaseCueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'releaseCue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sanskritNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sanskritName',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sanskritNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sanskritName',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sanskritNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sanskritName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sanskritNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sanskritName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sideTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sideType',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> sideTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sideType',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
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

extension IsarStepTemplateModelQueryObject on QueryBuilder<
    IsarStepTemplateModel, IsarStepTemplateModel, QFilterCondition> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel,
          QAfterFilterCondition>
      breathCuesElement(FilterQuery<IsarBreathCueEntryModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'breathCues');
    });
  }
}

extension IsarStepTemplateModelQueryLinks on QueryBuilder<IsarStepTemplateModel,
    IsarStepTemplateModel, QFilterCondition> {}

extension IsarStepTemplateModelQuerySortBy
    on QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QSortBy> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByBeginnerModificationNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByBeginnerModificationNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByBreathCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCautionNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCautionNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByIsBalancePoseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByPoseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByPoseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByPreparationCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByPreparationCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByReleaseCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByReleaseCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortBySanskritName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortBySanskritNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortBySideType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortBySideTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarStepTemplateModelQuerySortThenBy
    on QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QSortThenBy> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByBeginnerModificationNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByBeginnerModificationNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerModificationNote', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByBreathCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathCount', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCautionNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCautionNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cautionNote', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByIsBalancePoseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBalancePose', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByPoseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByPoseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poseName', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByPreparationCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByPreparationCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preparationCue', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByReleaseCue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByReleaseCueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseCue', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenBySanskritName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenBySanskritNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanskritName', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenBySideType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenBySideTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sideType', Sort.desc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarStepTemplateModelQueryWhereDistinct
    on QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct> {
  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByBeginnerModificationNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beginnerModificationNote',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByBreathCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breathCount');
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByCautionNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cautionNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByImagePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePaths');
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByIsBalancePose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBalancePose');
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByPoseName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByPreparationCue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preparationCue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByReleaseCue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseCue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctBySanskritName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sanskritName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctBySideType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sideType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarStepTemplateModel, IsarStepTemplateModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarStepTemplateModelQueryProperty on QueryBuilder<
    IsarStepTemplateModel, IsarStepTemplateModel, QQueryProperty> {
  QueryBuilder<IsarStepTemplateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String?, QQueryOperations>
      beginnerModificationNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beginnerModificationNote');
    });
  }

  QueryBuilder<IsarStepTemplateModel, int, QQueryOperations>
      breathCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathCount');
    });
  }

  QueryBuilder<IsarStepTemplateModel, List<IsarBreathCueEntryModel>,
      QQueryOperations> breathCuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathCues');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String?, QQueryOperations>
      cautionNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cautionNote');
    });
  }

  QueryBuilder<IsarStepTemplateModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarStepTemplateModel, List<String>, QQueryOperations>
      imagePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePaths');
    });
  }

  QueryBuilder<IsarStepTemplateModel, bool, QQueryOperations>
      isBalancePoseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBalancePose');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String, QQueryOperations>
      poseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poseName');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String, QQueryOperations>
      preparationCueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preparationCue');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String, QQueryOperations>
      releaseCueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseCue');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String?, QQueryOperations>
      sanskritNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sanskritName');
    });
  }

  QueryBuilder<IsarStepTemplateModel, String, QQueryOperations>
      sideTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sideType');
    });
  }

  QueryBuilder<IsarStepTemplateModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
