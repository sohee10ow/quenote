enum StepTemplateCategory { repeating, warmup, cooldown, other }

extension StepTemplateCategoryLabel on StepTemplateCategory {
  String get label {
    switch (this) {
      case StepTemplateCategory.repeating:
        return '반복 동작';
      case StepTemplateCategory.warmup:
        return '시작 스트레칭';
      case StepTemplateCategory.cooldown:
        return '마무리';
      case StepTemplateCategory.other:
        return '기타';
    }
  }
}
