import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/sequence/presentation/args/sequence_route_args.dart';
import 'package:quenote/features/sequence/presentation/screens/sequence_editor_screen.dart';
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

  testWidgets('제목 없이 저장하면 생성되지 않는다', (tester) async {
    final repository = _FakeSequenceRepository();

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceEditorScreen(),
      ),
    );

    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.createCallCount, 0);
    expect(find.text('새 시퀀스'), findsOneWidget);
  });

  testWidgets('제목 입력 후 저장하면 상세 화면으로 대체 이동한다', (tester) async {
    final repository = _FakeSequenceRepository();
    SequenceDetailRouteArgs? receivedArgs;

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceEditorScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceDetail) {
            receivedArgs = settings.arguments as SequenceDetailRouteArgs;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('상세 화면')),
            );
          }
          return null;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '아침 활력 요가');
    await tester.enterText(
      find.byType(TextFormField).last,
      '호흡과 중심 정렬에 집중합니다.',
    );
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(repository.createCallCount, 1);
    expect(repository.lastTitle, '아침 활력 요가');
    expect(repository.lastDescription, '호흡과 중심 정렬에 집중합니다.');
    expect(repository.lastLevel, SequenceLevel.beginner);
    expect(receivedArgs?.sequenceId, 42);
    expect(find.text('상세 화면'), findsOneWidget);
  });

  testWidgets('입력 중 뒤로가기를 누르면 폐기 확인창이 열린다', (tester) async {
    final repository = _FakeSequenceRepository();

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceEditorScreen(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).last, '메모 초안');
    await tester.tap(find.byIcon(CupertinoIcons.back));
    await tester.pumpAndSettle();

    expect(find.text('저장하지 않은 변경사항이 있습니다. 나가시겠어요?'), findsOneWidget);
    expect(find.text('나가기'), findsOneWidget);
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

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository() : super(_unsupportedRead);

  int createCallCount = 0;
  String? lastTitle;
  String? lastDescription;
  SequenceLevel? lastLevel;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<int> createSequence({
    required String title,
    String? description,
    SequenceLevel level = SequenceLevel.beginner,
    List<String> tags = const <String>[],
  }) async {
    createCallCount += 1;
    lastTitle = title;
    lastDescription = description;
    lastLevel = level;
    return 42;
  }
}
