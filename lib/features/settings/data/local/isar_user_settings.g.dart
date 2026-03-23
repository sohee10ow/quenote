// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_user_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarUserSettingsModelCollection on Isar {
  IsarCollection<IsarUserSettingsModel> get isarUserSettingsModels =>
      this.collection();
}

const IsarUserSettingsModelSchema = CollectionSchema(
  name: r'IsarUserSettingsModel',
  id: -7354710303954557224,
  properties: {
    r'defaultShareFormat': PropertySchema(
      id: 0,
      name: r'defaultShareFormat',
      type: IsarType.string,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 1,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
    r'selectedTheme': PropertySchema(
      id: 2,
      name: r'selectedTheme',
      type: IsarType.string,
    ),
    r'textSize': PropertySchema(
      id: 3,
      name: r'textSize',
      type: IsarType.string,
    )
  },
  estimateSize: _isarUserSettingsModelEstimateSize,
  serialize: _isarUserSettingsModelSerialize,
  deserialize: _isarUserSettingsModelDeserialize,
  deserializeProp: _isarUserSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarUserSettingsModelGetId,
  getLinks: _isarUserSettingsModelGetLinks,
  attach: _isarUserSettingsModelAttach,
  version: '3.1.0+1',
);

int _isarUserSettingsModelEstimateSize(
  IsarUserSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.defaultShareFormat.length * 3;
  bytesCount += 3 + object.selectedTheme.length * 3;
  bytesCount += 3 + object.textSize.length * 3;
  return bytesCount;
}

void _isarUserSettingsModelSerialize(
  IsarUserSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.defaultShareFormat);
  writer.writeBool(offsets[1], object.onboardingCompleted);
  writer.writeString(offsets[2], object.selectedTheme);
  writer.writeString(offsets[3], object.textSize);
}

IsarUserSettingsModel _isarUserSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarUserSettingsModel();
  object.defaultShareFormat = reader.readString(offsets[0]);
  object.id = id;
  object.onboardingCompleted = reader.readBool(offsets[1]);
  object.selectedTheme = reader.readString(offsets[2]);
  object.textSize = reader.readString(offsets[3]);
  return object;
}

P _isarUserSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarUserSettingsModelGetId(IsarUserSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarUserSettingsModelGetLinks(
    IsarUserSettingsModel object) {
  return [];
}

void _isarUserSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, IsarUserSettingsModel object) {
  object.id = id;
}

extension IsarUserSettingsModelQueryWhereSort
    on QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QWhere> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarUserSettingsModelQueryWhere on QueryBuilder<IsarUserSettingsModel,
    IsarUserSettingsModel, QWhereClause> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhereClause>
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

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterWhereClause>
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

extension IsarUserSettingsModelQueryFilter on QueryBuilder<
    IsarUserSettingsModel, IsarUserSettingsModel, QFilterCondition> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultShareFormat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      defaultShareFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultShareFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      defaultShareFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultShareFormat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultShareFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> defaultShareFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultShareFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
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

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
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

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
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

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> onboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedTheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      selectedThemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedTheme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      selectedThemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedTheme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedTheme',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> selectedThemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedTheme',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      textSizeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textSize',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
          QAfterFilterCondition>
      textSizeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textSize',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textSize',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel,
      QAfterFilterCondition> textSizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textSize',
        value: '',
      ));
    });
  }
}

extension IsarUserSettingsModelQueryObject on QueryBuilder<
    IsarUserSettingsModel, IsarUserSettingsModel, QFilterCondition> {}

extension IsarUserSettingsModelQueryLinks on QueryBuilder<IsarUserSettingsModel,
    IsarUserSettingsModel, QFilterCondition> {}

extension IsarUserSettingsModelQuerySortBy
    on QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QSortBy> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByDefaultShareFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultShareFormat', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByDefaultShareFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultShareFormat', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByTextSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textSize', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      sortByTextSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textSize', Sort.desc);
    });
  }
}

extension IsarUserSettingsModelQuerySortThenBy
    on QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QSortThenBy> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByDefaultShareFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultShareFormat', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByDefaultShareFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultShareFormat', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByTextSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textSize', Sort.asc);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QAfterSortBy>
      thenByTextSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textSize', Sort.desc);
    });
  }
}

extension IsarUserSettingsModelQueryWhereDistinct
    on QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QDistinct> {
  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QDistinct>
      distinctByDefaultShareFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultShareFormat',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QDistinct>
      distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QDistinct>
      distinctBySelectedTheme({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedTheme',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserSettingsModel, IsarUserSettingsModel, QDistinct>
      distinctByTextSize({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textSize', caseSensitive: caseSensitive);
    });
  }
}

extension IsarUserSettingsModelQueryProperty on QueryBuilder<
    IsarUserSettingsModel, IsarUserSettingsModel, QQueryProperty> {
  QueryBuilder<IsarUserSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarUserSettingsModel, String, QQueryOperations>
      defaultShareFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultShareFormat');
    });
  }

  QueryBuilder<IsarUserSettingsModel, bool, QQueryOperations>
      onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }

  QueryBuilder<IsarUserSettingsModel, String, QQueryOperations>
      selectedThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedTheme');
    });
  }

  QueryBuilder<IsarUserSettingsModel, String, QQueryOperations>
      textSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textSize');
    });
  }
}
