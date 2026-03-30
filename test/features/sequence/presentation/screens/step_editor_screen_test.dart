import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/init/app_startup_controller.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/breath_cue_entry.dart';
import 'package:quenote/features/sequence/domain/entities/sequence_step.dart';
import 'package:quenote/features/sequence/domain/entities/step_template.dart';
import 'package:quenote/features/sequence/domain/enums/side_type.dart';
import 'package:quenote/features/sequence/domain/enums/step_template_category.dart';
import 'package:quenote/features/sequence/presentation/screens/step_editor_screen.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets('새 동작 추가 화면이 Figma 구조를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository();

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepEditorScreen(sequenceId: 1),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('새 동작 추가'), findsOneWidget);
    expect(find.text('기본 정보'), findsOneWidget);
    expect(find.text('준비동작 큐잉'), findsOneWidget);
    expect(find.text('호흡 큐잉'), findsOneWidget);
    expect(find.text('동작 푸는 큐잉'), findsOneWidget);
    expect(find.text('주의사항'), findsOneWidget);
    expect(find.text('초보자 변형 동작'), findsOneWidget);
    expect(find.text('동작 사진'), findsOneWidget);
    expect(find.text('카메라'), findsOneWidget);
    expect(find.text('갤러리'), findsOneWidget);
    expect(find.text('동작 추가하기'), findsOneWidget);
  });

  testWidgets('동작 이름이 없으면 저장되지 않는다', (tester) async {
    final repository = _FakeSequenceRepository();

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepEditorScreen(sequenceId: 1),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.upsertCallCount, 0);
    expect(find.text('새 동작 추가'), findsOneWidget);
  });

  testWidgets('이름 입력 후 저장하면 upsert 뒤 이전 화면으로 돌아간다', (tester) async {
    final repository = _FakeSequenceRepository();

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepEditorScreen(sequenceId: 1),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '다운독');
    await tester.pump();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.upsertCallCount, 1);
    expect(repository.lastSequenceId, 1);
    expect(repository.lastPoseName, '다운독');
    expect(repository.lastBreathCount, 3);
    expect(find.text('호스트 화면'), findsOneWidget);
  });

  testWidgets('편집 모드에서는 동작 편집 제목과 삭제 버튼이 보인다', (tester) async {
    final repository = _FakeSequenceRepository(existingStep: _sampleStep());

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepEditorScreen(sequenceId: 1, stepId: 9),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('동작 편집'), findsOneWidget);
    expect(find.text('변경사항 저장'), findsOneWidget);
    expect(find.text('동작 삭제'), findsOneWidget);
    expect(find.text('전사 1'), findsOneWidget);
  });

  testWidgets('템플릿으로 시작하면 새 동작 추가 상태로 템플릿 값이 채워진다', (tester) async {
    final repository = _FakeSequenceRepository(
      existingTemplate: _sampleTemplate(),
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const StepEditorScreen(sequenceId: 1, templateId: 3),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('새 동작 추가'), findsOneWidget);
    expect(find.text('동작 삭제'), findsNothing);
    expect(find.text('비둘기 자세 준비'), findsOneWidget);
    expect(find.text('왼쪽'), findsOneWidget);
  });
}

Widget _buildTestApp({
  required SequenceRepository repository,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      sequenceRepositoryProvider.overrideWithValue(repository),
      isProEnabledProvider.overrideWithValue(true),
    ],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: _StepEditorTestHost(child: child),
    ),
  );
}

class _StepEditorTestHost extends StatefulWidget {
  const _StepEditorTestHost({required this.child});

  final Widget child;

  @override
  State<_StepEditorTestHost> createState() => _StepEditorTestHostState();
}

class _StepEditorTestHostState extends State<_StepEditorTestHost> {
  bool _pushed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pushed) {
      return;
    }
    _pushed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => widget.child));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('호스트 화면')));
  }
}

SequenceStep _sampleStep() {
  return SequenceStep(
    id: 9,
    sequenceId: 1,
    orderIndex: 0,
    poseName: '전사 1',
    sanskritName: null,
    sideType: SideType.both,
    isBalancePose: true,
    breathCount: 2,
    preparationCue: '다리를 넓게 벌립니다.',
    breathCues: const [
      BreathCueEntry(breathIndex: 1, text: '두 팔을 들어 올립니다.'),
      BreathCueEntry(breathIndex: 2, text: '골반 정렬을 맞춥니다.'),
    ],
    releaseCue: '손을 내려 중심으로 돌아옵니다.',
    cautionNote: '허리가 꺾이지 않도록 주의하세요.',
    beginnerModificationNote: '앞무릎 각도를 줄여도 됩니다.',
    imagePaths: const [],
    createdAt: DateTime(2026, 3, 18),
    updatedAt: DateTime(2026, 3, 19),
  );
}

StepTemplate _sampleTemplate() {
  return StepTemplate(
    id: 3,
    category: StepTemplateCategory.repeating,
    poseName: '비둘기 자세 준비',
    sanskritName: null,
    sideType: SideType.left,
    isBalancePose: false,
    breathCount: 2,
    preparationCue: '왼쪽 무릎을 앞으로 가져옵니다.',
    breathCues: const [
      BreathCueEntry(breathIndex: 1, text: '골반을 정면으로 맞춥니다.'),
      BreathCueEntry(breathIndex: 2, text: '숨을 길게 내쉽니다.'),
    ],
    releaseCue: '손으로 바닥을 밀어 돌아옵니다.',
    cautionNote: null,
    beginnerModificationNote: null,
    imagePaths: const [],
    createdAt: DateTime(2026, 3, 18),
    updatedAt: DateTime(2026, 3, 19),
  );
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({this.existingStep, this.existingTemplate})
    : super(_unsupportedRead);

  final SequenceStep? existingStep;
  final StepTemplate? existingTemplate;

  int upsertCallCount = 0;
  int? lastSequenceId;
  int? lastStepId;
  String? lastPoseName;
  int? lastBreathCount;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<SequenceStep?> findStepById(int stepId) async {
    return existingStep?.id == stepId ? existingStep : null;
  }

  @override
  Future<StepTemplate?> findStepTemplateById(int templateId) async {
    return existingTemplate?.id == templateId ? existingTemplate : null;
  }

  @override
  Future<void> upsertStep({
    required int sequenceId,
    int? stepId,
    required String poseName,
    required String? sanskritName,
    required SideType sideType,
    required bool isBalancePose,
    required int breathCount,
    required String preparationCue,
    required List<String> breathCues,
    required String releaseCue,
    required String? cautionNote,
    required String? beginnerModificationNote,
    required List<String> imagePaths,
  }) async {
    upsertCallCount += 1;
    lastSequenceId = sequenceId;
    lastStepId = stepId;
    lastPoseName = poseName;
    lastBreathCount = breathCount;
  }
}
