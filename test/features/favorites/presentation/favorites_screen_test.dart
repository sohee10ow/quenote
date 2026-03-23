import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/favorites/presentation/favorites_screen.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/sequence/presentation/args/sequence_route_args.dart';
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

  testWidgets('즐겨찾기가 없으면 빈 상태를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(
      favorites: const [],
      stepCounts: const {},
    );

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('즐겨찾기'), findsOneWidget);
    expect(find.text('0개의 즐겨찾기'), findsOneWidget);
    expect(find.text('아직 즐겨찾기한 시퀀스가 없어요\n자주 사용하는 시퀀스를 추가해보세요'), findsOneWidget);
  });

  testWidgets('즐겨찾기 카드 탭 시 시퀀스 상세로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      favorites: [_sampleFavorite()],
      stepCounts: const {1: 3},
    );
    SequenceDetailRouteArgs? receivedArgs;

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const FavoritesScreen(),
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
    await tester.pumpAndSettle();

    expect(find.text('1개의 즐겨찾기'), findsOneWidget);
    expect(find.text('3개 동작 • 3월 19일'), findsOneWidget);

    await tester.tap(find.text('아침 활력 요가'));
    await tester.pumpAndSettle();

    expect(receivedArgs?.sequenceId, 1);
    expect(find.text('상세 화면'), findsOneWidget);
  });

  testWidgets('카드의 하트 버튼을 누르면 즐겨찾기 토글을 호출한다', (tester) async {
    final repository = _FakeSequenceRepository(
      favorites: [_sampleFavorite()],
      stepCounts: const {1: 3},
    );

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_rounded).last);
    await tester.pumpAndSettle();

    expect(repository.toggleFavoriteCallCount, 1);
    expect(repository.lastToggledSequenceId, 1);
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

Sequence _sampleFavorite() {
  return Sequence(
    id: 1,
    title: '아침 활력 요가',
    description: '호흡과 중심 정렬에 집중합니다.',
    level: SequenceLevel.beginner,
    tags: const ['아침'],
    isFavorite: true,
    createdAt: DateTime(2026, 3, 10),
    updatedAt: DateTime(2026, 3, 19),
  );
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({
    required List<Sequence> favorites,
    required Map<int, int> stepCounts,
  }) : _favorites = List<Sequence>.from(favorites),
       _stepCounts = Map<int, int>.from(stepCounts),
       super(_unsupportedRead);

  final List<Sequence> _favorites;
  final Map<int, int> _stepCounts;
  int toggleFavoriteCallCount = 0;
  int? lastToggledSequenceId;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<List<Sequence>> fetchFavoriteSequences() async {
    return List<Sequence>.from(_favorites);
  }

  @override
  Future<Map<int, int>> fetchStepCountsBySequence() async {
    return Map<int, int>.from(_stepCounts);
  }

  @override
  Future<void> toggleFavorite(int sequenceId) async {
    toggleFavoriteCallCount += 1;
    lastToggledSequenceId = sequenceId;
  }
}
