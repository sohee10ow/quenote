import 'package:isar/isar.dart';

import '../../features/sequence/data/local/isar_sequence.dart';
import '../../features/sequence/data/local/isar_sequence_step.dart';
import '../../features/sequence/data/local/isar_step_template.dart';
import '../../features/settings/data/local/isar_user_settings.dart';

const List<CollectionSchema<dynamic>> isarSchemas = <CollectionSchema<dynamic>>[
  IsarSequenceModelSchema,
  IsarSequenceStepModelSchema,
  IsarStepTemplateModelSchema,
  IsarUserSettingsModelSchema,
];
