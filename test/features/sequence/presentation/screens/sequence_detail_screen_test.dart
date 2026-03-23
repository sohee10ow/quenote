import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:quenote/features/sequence/presentation/screens/sequence_detail_screen.dart';
import 'package:quenote/features/settings/domain/enums/share_format_type.dart';
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

  testWidgets('시퀀스 상세 화면이 헤더와 동작 리스트를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: _sampleSteps(),
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceDetailScreen(sequenceId: 1),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('아침 활력 요가'), findsOneWidget);
    expect(find.text('편집'), findsNothing);
    expect(find.text('텍스트 복사'), findsOneWidget);
    expect(find.text('공유'), findsOneWidget);
    expect(find.text('수업 노트'), findsOneWidget);
    expect(find.text('동작 순서'), findsOneWidget);
    expect(find.text('순서 변경'), findsOneWidget);
    expect(find.text('다운독'), findsOneWidget);
    expect(find.text('전사 1'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('동작 추가'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('동작 추가'), findsOneWidget);
    expect(find.text('시퀀스 삭제'), findsOneWidget);
  });

  testWidgets('시퀀스를 삭제하면 목록 화면으로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: _sampleSteps(),
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceDetailScreen(sequenceId: 1),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceList) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('목록 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('시퀀스 삭제'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('시퀀스 삭제'));
    await tester.pumpAndSettle();

    expect(find.text('시퀀스 삭제'), findsNWidgets(2));
    expect(find.textContaining('삭제하시겠어요?'), findsOneWidget);

    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();

    expect(repository.deleteCallCount, 1);
    expect(find.text('목록 화면'), findsOneWidget);
  });

  testWidgets('기본 공유 형식이 짧게면 텍스트 복사 결과가 짧은 형식으로 바뀐다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequence: _sampleSequence(),
      steps: _sampleSteps(),
    );
    String? copiedText;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            copiedText = (methodCall.arguments as Map)['text'] as String?;
          }
          return null;
        });

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceDetailScreen(sequenceId: 1),
        shareFormat: ShareFormatType.short,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('텍스트 복사'));
    await tester.pumpAndSettle();

    expect(copiedText, '아침 활력 요가\n2개 동작\n1. 다운독\n2. 전사 1');
    await tester.pump(const Duration(seconds: 2));
  });
}

Widget _buildTestApp({
  required SequenceRepository repository,
  required Widget child,
  RouteFactory? onGenerateRoute,
  ShareFormatType shareFormat = ShareFormatType.full,
}) {
  return ProviderScope(
    overrides: [
      sequenceRepositoryProvider.overrideWithValue(repository),
      appShareFormatProvider.overrideWithValue(shareFormat),
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
    tags: const ['회복', '아침'],
    isFavorite: false,
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

List<SequenceStep> _sampleSteps() {
  return [
    SequenceStep(
      id: 10,
      sequenceId: 1,
      orderIndex: 0,
      poseName: '다운독',
      sanskritName: null,
      sideType: SideType.none,
      isBalancePose: false,
      breathCount: 2,
      preparationCue: '손바닥으로 바닥을 밀어냅니다.',
      breathCues: [
        BreathCueEntry(breathIndex: 1, text: '척추를 길게 늘립니다.'),
        BreathCueEntry(breathIndex: 2, text: ''),
      ],
      releaseCue: '무릎을 천천히 바닥에 내립니다.',
      cautionNote: null,
      beginnerModificationNote: null,
      imagePaths: const [],
      createdAt: DateTime(2026, 3, 10),
      updatedAt: DateTime(2026, 3, 19),
    ),
    SequenceStep(
      id: 11,
      sequenceId: 1,
      orderIndex: 1,
      poseName: '전사 1',
      sanskritName: null,
      sideType: SideType.both,
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
    ),
  ];
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({
    required Sequence? sequence,
    required List<SequenceStep> steps,
  }) : _sequence = sequence,
       _steps = List<SequenceStep>.from(steps),
       super(_unsupportedRead);

  Sequence? _sequence;
  final List<SequenceStep> _steps;
  int deleteCallCount = 0;

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
  Future<void> deleteSequence(int sequenceId) async {
    deleteCallCount += 1;
    if (_sequence?.id == sequenceId) {
      _sequence = null;
    }
  }
}
