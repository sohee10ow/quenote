import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/sequence/presentation/args/sequence_route_args.dart';
import 'package:quenote/features/sequence/presentation/screens/step_duplicate_target_screen.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  testWidgets('현재 시퀀스를 제외한 목록을 보여주고 선택 시 대상 시퀀스로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequences: [
        _sequence(1, '현재 시퀀스'),
        _sequence(2, '저녁 이완'),
        _sequence(3, '아침 활력'),
      ],
      stepCounts: const {1: 3, 2: 5, 3: 4},
    );
    SequenceDetailRouteArgs? receivedArgs;

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDuplicateTargetScreen(
          sourceSequenceId: 1,
          sourceStepId: 10,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceDetail) {
            receivedArgs = settings.arguments as SequenceDetailRouteArgs;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('대상 시퀀스 상세')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('현재 시퀀스'), findsNothing);
    expect(find.text('저녁 이완'), findsOneWidget);
    expect(find.text('아침 활력'), findsOneWidget);

    await tester.tap(find.text('저녁 이완'));
    await tester.pumpAndSettle();

    expect(repository.lastTargetSequenceId, 2);
    expect(repository.lastSourceStepId, 10);
    expect(receivedArgs?.sequenceId, 2);
    expect(find.text('대상 시퀀스 상세'), findsOneWidget);
  });
}

Widget _buildTestApp({
  required SequenceRepository repository,
  required Widget child,
  RouteFactory? onGenerateRoute,
}) {
  return ProviderScope(
    overrides: [sequenceRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: child,
      onGenerateRoute: onGenerateRoute,
    ),
  );
}

Sequence _sequence(int id, String title) {
  return Sequence(
    id: id,
    title: title,
    description: null,
    level: SequenceLevel.beginner,
    tags: const [],
    isFavorite: false,
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({
    required List<Sequence> sequences,
    required Map<int, int> stepCounts,
  }) : _sequences = List<Sequence>.from(sequences),
       _stepCounts = Map<int, int>.from(stepCounts),
       super(_unsupportedRead);

  final List<Sequence> _sequences;
  final Map<int, int> _stepCounts;
  int? lastSourceStepId;
  int? lastTargetSequenceId;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<List<Sequence>> fetchSequences() async {
    return List<Sequence>.from(_sequences);
  }

  @override
  Future<Map<int, int>> fetchStepCountsBySequence() async {
    return Map<int, int>.from(_stepCounts);
  }

  @override
  Future<StepDuplicationResult> duplicateStepIntoSequence({
    required int stepId,
    required int targetSequenceId,
  }) async {
    lastSourceStepId = stepId;
    lastTargetSequenceId = targetSequenceId;
    return StepDuplicationResult(
      targetSequenceId: targetSequenceId,
      newStepId: 999,
    );
  }
}
