class SequenceDetailRouteArgs {
  const SequenceDetailRouteArgs({required this.sequenceId});

  final int sequenceId;
}

class StepEditorRouteArgs {
  const StepEditorRouteArgs({required this.sequenceId, this.stepId});

  final int sequenceId;
  final int? stepId;
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
