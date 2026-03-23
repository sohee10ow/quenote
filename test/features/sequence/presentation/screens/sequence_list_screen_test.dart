import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/sequence/presentation/screens/sequence_list_screen.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  testWidgets('검색과 즐겨찾기 필터가 시퀀스 목록에 반영된다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequences: [
        Sequence(
          id: 1,
          title: '아침 활력 요가',
          description: '호흡 중심 메모',
          level: SequenceLevel.beginner,
          tags: const [],
          isFavorite: true,
          createdAt: DateTime(2026, 3, 10),
          updatedAt: DateTime(2026, 3, 18),
        ),
        Sequence(
          id: 2,
          title: '저녁 이완 스트레칭',
          description: null,
          level: SequenceLevel.beginner,
          tags: const [],
          isFavorite: false,
          createdAt: DateTime(2026, 3, 1),
          updatedAt: DateTime(2026, 3, 5),
        ),
      ],
      stepCounts: const {1: 4, 2: 12},
    );

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const SequenceListScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('2개의 시퀀스'), findsOneWidget);
    expect(find.text('아침 활력 요가'), findsOneWidget);
    expect(find.text('저녁 이완 스트레칭'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '아침');
    await tester.pumpAndSettle();

    expect(find.text('1개의 시퀀스'), findsOneWidget);
    expect(find.text('아침 활력 요가'), findsOneWidget);
    expect(find.text('저녁 이완 스트레칭'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('즐겨찾기'));
    await tester.pumpAndSettle();

    expect(find.text('1개의 시퀀스'), findsOneWidget);
    expect(find.text('아침 활력 요가'), findsOneWidget);
    expect(find.text('저녁 이완 스트레칭'), findsNothing);
  });

  testWidgets('플로팅 버튼을 누르면 새 시퀀스 화면으로 이동한다', (tester) async {
    final repository = _FakeSequenceRepository(
      sequences: const [],
      stepCounts: const {},
    );

    await tester.pumpWidget(
      _buildTestApp(
        repository: repository,
        child: const SequenceListScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceEditor) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('새 시퀀스 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('새 시퀀스 화면'), findsOneWidget);
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
  _FakeSequenceRepository({
    required List<Sequence> sequences,
    required Map<int, int> stepCounts,
  }) : _sequences = List<Sequence>.from(sequences),
       _stepCounts = Map<int, int>.from(stepCounts),
       super(_unsupportedRead);

  List<Sequence> _sequences;
  final Map<int, int> _stepCounts;

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
  Future<void> toggleFavorite(int sequenceId) async {
    _sequences = _sequences
        .map((sequence) {
          if (sequence.id != sequenceId) {
            return sequence;
          }

          return Sequence(
            id: sequence.id,
            title: sequence.title,
            description: sequence.description,
            level: sequence.level,
            tags: sequence.tags,
            isFavorite: !sequence.isFavorite,
            createdAt: sequence.createdAt,
            updatedAt: sequence.updatedAt,
          );
        })
        .toList(growable: false);
  }
}
