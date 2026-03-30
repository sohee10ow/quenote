import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/init/app_startup_controller.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/breath_cue_entry.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/entities/sequence_step.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/sequence/domain/enums/side_type.dart';
import 'package:quenote/features/sequence/domain/enums/step_template_category.dart';
import 'package:quenote/features/sequence/presentation/args/sequence_route_args.dart';
import 'package:quenote/features/sequence/presentation/screens/step_detail_screen.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  testWidgets('구조화된 큐잉이 있으면 step 상세 섹션이 보인다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 10),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('다운독'), findsOneWidget);
    expect(find.text('아침 활력 요가'), findsOneWidget);
    expect(find.text('2호흡'), findsOneWidget);
    expect(find.text('밸런스 동작'), findsOneWidget);
    expect(find.text('동작 사진'), findsOneWidget);
    expect(find.text('준비동작 큐잉'), findsOneWidget);
    expect(find.text('호흡 큐잉'), findsOneWidget);
    expect(find.text('동작 푸는 큐잉'), findsOneWidget);
    expect(find.text('주의사항'), findsOneWidget);
    expect(find.text('초보자 변형 동작'), findsOneWidget);
  });

  testWidgets('편집 버튼을 누르면 기존 StepEditor로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 10),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.stepEditor) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('편집 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('수정'));
    await tester.pumpAndSettle();

    expect(find.text('편집 화면'), findsOneWidget);
  });

  testWidgets('동작 복제 메뉴에서 3가지 복제 경로를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 10),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('동작 복제'));
    await tester.pumpAndSettle();

    expect(find.text('현재 시퀀스에 넣기'), findsOneWidget);
    expect(find.text('새로운 시퀀스에 넣기'), findsOneWidget);
    expect(find.text('다른 시퀀스에 넣기'), findsOneWidget);
  });

  testWidgets('즐겨찾기에 저장을 선택하면 템플릿 저장을 호출한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 10),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('즐겨찾기에 저장'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('시작 스트레칭'));
    await tester.pumpAndSettle();

    expect(repository.saveTemplateCallCount, 1);
    expect(repository.lastSavedTemplateStepId, 10);
    expect(repository.lastSavedTemplateCategory, StepTemplateCategory.warmup);
    expect(find.text('즐겨찾기에 저장했어요.'), findsOneWidget);
  });

  testWidgets('새로운 시퀀스에 넣기를 선택하면 시퀀스 생성 화면으로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
    );
    SequenceEditorRouteArgs? receivedArgs;

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 10),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceEditor) {
            receivedArgs = settings.arguments as SequenceEditorRouteArgs;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('시퀀스 생성 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('동작 복제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('새로운 시퀀스에 넣기'));
    await tester.pumpAndSettle();

    expect(receivedArgs?.pendingDuplicateSourceStepId, 10);
    expect(find.text('시퀀스 생성 화면'), findsOneWidget);
  });

  testWidgets('현재 시퀀스에 넣기를 선택하면 기존 시퀀스 상세로 돌아간다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleStructuredStep()],
      duplicatedStepResult: const StepDuplicationResult(
        targetSequenceId: 1,
        newStepId: 77,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sequenceRepositoryProvider.overrideWithValue(repository),
          isProEnabledProvider.overrideWithValue(true),
        ],
        child: MaterialApp(
          theme: AppTheme.fromType(AppThemeType.sage),
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const StepDetailScreen(sequenceId: 1, stepId: 10),
                        ),
                      );
                    },
                    child: const Text('원본 시퀀스 상세'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('원본 시퀀스 상세'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('동작 복제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('현재 시퀀스에 넣기'));
    await tester.pumpAndSettle();

    expect(repository.lastDuplicatedStepId, 10);
    expect(find.text('원본 시퀀스 상세'), findsOneWidget);
    expect(find.byType(StepDetailScreen), findsNothing);
  });

  testWidgets('표시할 큐잉이 없으면 empty state를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: [_sampleEmptyStep()],
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepDetailScreen(sequenceId: 1, stepId: 11),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('아직 큐잉 노트가 없어요\n편집 버튼을 눌러 작성해보세요'), findsOneWidget);
    expect(find.text('큐잉 노트 작성'), findsOneWidget);
  });
}

Widget _buildTestApp({
  required SequenceRepository repository,
  required Widget child,
  RouteFactory? onGenerateRoute,
}) {
  return ProviderScope(
    overrides: [
      sequenceRepositoryProvider.overrideWithValue(repository),
      isProEnabledProvider.overrideWithValue(true),
    ],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: child,
      onGenerateRoute: onGenerateRoute,
    ),
  );
}

Sequence _sampleSequence() {
  return Sequence(
    id: 1,
    title: '아침 활력 요가',
    description: '호흡과 중심 정렬에 집중하는 수업입니다.',
    level: SequenceLevel.beginner,
    tags: const ['회복'],
    isFavorite: false,
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

SequenceStep _sampleStructuredStep() {
  return SequenceStep(
    id: 10,
    sequenceId: 1,
    orderIndex: 0,
    poseName: '다운독',
    sanskritName: null,
    sideType: SideType.both,
    isBalancePose: true,
    breathCount: 2,
    preparationCue: '손바닥으로 바닥을 밀어냅니다.',
    breathCues: [
      BreathCueEntry(breathIndex: 1, text: '척추를 길게 늘립니다.'),
      BreathCueEntry(breathIndex: 2, text: '어깨 힘을 부드럽게 풀어냅니다.'),
    ],
    releaseCue: '무릎을 천천히 바닥에 내립니다.',
    cautionNote: '손목 부담이 크면 블록을 사용하세요.',
    beginnerModificationNote: '무릎을 살짝 굽혀서 시작해도 됩니다.',
    imagePaths: const ['/tmp/step-detail-image.png'],
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

SequenceStep _sampleEmptyStep() {
  return SequenceStep(
    id: 11,
    sequenceId: 1,
    orderIndex: 1,
    poseName: '전사 1',
    sanskritName: null,
    sideType: SideType.none,
    isBalancePose: false,
    breathCount: 1,
    preparationCue: '',
    breathCues: [BreathCueEntry(breathIndex: 1, text: '')],
    releaseCue: '',
    cautionNote: null,
    beginnerModificationNote: null,
    imagePaths: const [],
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({
    required Sequence? sequence,
    required List<SequenceStep> steps,
    this.duplicatedStepResult,
  }) : _sequence = sequence,
       _steps = List<SequenceStep>.from(steps),
       super(_unsupportedRead);

  final Sequence? _sequence;
  final List<SequenceStep> _steps;
  final StepDuplicationResult? duplicatedStepResult;
  int? lastDuplicatedStepId;
  int saveTemplateCallCount = 0;
  int? lastSavedTemplateStepId;
  StepTemplateCategory? lastSavedTemplateCategory;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<Sequence?> findSequenceById(int id) async {
    return _sequence?.id == id ? _sequence : null;
  }

  @override
  Future<List<SequenceStep>> fetchStepsBySequence(int sequenceId) async {
    return _steps
        .where((step) => step.sequenceId == sequenceId)
        .toList(growable: false);
  }

  @override
  Future<StepDuplicationResult> duplicateStepIntoSameSequence(
    int stepId,
  ) async {
    lastDuplicatedStepId = stepId;
    return duplicatedStepResult ??
        const StepDuplicationResult(targetSequenceId: 1, newStepId: 999);
  }

  @override
  Future<int> saveStepAsTemplate({
    required int stepId,
    required StepTemplateCategory category,
  }) async {
    saveTemplateCallCount += 1;
    lastSavedTemplateStepId = stepId;
    lastSavedTemplateCategory = category;
    return 101;
  }
}
