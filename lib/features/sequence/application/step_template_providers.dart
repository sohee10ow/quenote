import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/step_template.dart';
import '../domain/enums/step_template_category.dart';
import 'sequence_providers.dart';

final stepTemplateListProvider =
    FutureProvider.family<List<StepTemplate>, StepTemplateCategory?>(
      (ref, category) => ref
          .watch(sequenceRepositoryProvider)
          .fetchStepTemplates(category: category),
    );

final stepTemplateByIdProvider = FutureProvider.family<StepTemplate?, int>(
  (ref, templateId) =>
      ref.watch(sequenceRepositoryProvider).findStepTemplateById(templateId),
);
