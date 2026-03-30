class SequenceEditorRouteArgs {
  const SequenceEditorRouteArgs({this.pendingDuplicateSourceStepId});

  final int? pendingDuplicateSourceStepId;
}

class SequenceDetailRouteArgs {
  const SequenceDetailRouteArgs({required this.sequenceId});

  final int sequenceId;
}

class StepEditorRouteArgs {
  const StepEditorRouteArgs({
    required this.sequenceId,
    this.stepId,
    this.templateId,
  });

  final int sequenceId;
  final int? stepId;
  final int? templateId;
}

class StepDetailRouteArgs {
  const StepDetailRouteArgs({required this.sequenceId, required this.stepId});

  final int sequenceId;
  final int stepId;
}

class StepReorderRouteArgs {
  const StepReorderRouteArgs({required this.sequenceId});

  final int sequenceId;
}

class StepDuplicateTargetRouteArgs {
  const StepDuplicateTargetRouteArgs({
    required this.sourceSequenceId,
    required this.sourceStepId,
  });

  final int sourceSequenceId;
  final int sourceStepId;
}

class SequenceFullViewRouteArgs {
  const SequenceFullViewRouteArgs({required this.sequenceId});

  final int sequenceId;
}
