import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/router/app_routes.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/home/application/home_providers.dart';
import 'package:quenote/features/home/domain/entities/home_overview.dart';
import 'package:quenote/features/home/presentation/home_screen.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';
import 'package:quenote/app/init/app_startup_controller.dart';

void main() {
  testWidgets('시퀀스가 없으면 홈이 설명형 빈 상태와 생성 CTA를 보여준다', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        overview: const HomeOverview(
          hasSequences: false,
          favoriteSequences: <HomeSequenceSummary>[],
          recentSequences: <HomeSequenceSummary>[],
          recentCueNotes: <HomeRecentCueNoteSummary>[],
        ),
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

    expect(find.text('시퀀스를 만들고\n큐를 쌓는 요가 노트'), findsOneWidget);
    expect(find.text('새 시퀀스 시작'), findsOneWidget);
    expect(find.text('처음은 시퀀스부터 시작해요'), findsOneWidget);
    expect(find.text('시퀀스 생성'), findsOneWidget);
    expect(find.text('동작 추가'), findsOneWidget);
    expect(find.text('공유'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('새 시퀀스 시작'));
    await tester.pumpAndSettle();

    expect(find.text('새 시퀀스 화면'), findsOneWidget);
  });

  testWidgets('전체 시퀀스 보기 CTA를 누르면 시퀀스 목록 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        overview: HomeOverview(
          hasSequences: true,
          favoriteSequences: const <HomeSequenceSummary>[],
          recentSequences: [
            HomeSequenceSummary(sequence: _sampleSequence(), stepCount: 3),
          ],
          recentCueNotes: const <HomeRecentCueNoteSummary>[],
        ),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceList) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('시퀀스 목록 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('전체 시퀀스 보기'));
    await tester.pumpAndSettle();

    expect(find.text('시퀀스 목록 화면'), findsOneWidget);
  });

  testWidgets('최근 편집한 큐 노트를 누르면 시퀀스 상세 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        overview: HomeOverview(
          hasSequences: true,
          favoriteSequences: const <HomeSequenceSummary>[],
          recentSequences: [
            HomeSequenceSummary(sequence: _sampleSequence(), stepCount: 3),
          ],
          recentCueNotes: const [
            HomeRecentCueNoteSummary(
              sequenceId: 1,
              sequenceTitle: '아침 활력 요가',
              stepId: 11,
              stepOrder: 2,
              poseName: '전사 1',
              preview: '골반의 정면을 맞춥니다.',
            ),
          ],
        ),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.sequenceDetail) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('시퀀스 상세 화면')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('전사 1'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('전사 1'));
    await tester.pumpAndSettle();

    expect(find.text('시퀀스 상세 화면'), findsOneWidget);
  });
}

Widget _buildTestApp({
  required HomeOverview overview,
  RouteFactory? onGenerateRoute,
}) {
  return ProviderScope(
    overrides: [
      homeOverviewProvider.overrideWith((ref) async => overview),
      isProEnabledProvider.overrideWithValue(true),
    ],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: const HomeScreen(),
      onGenerateRoute: onGenerateRoute,
    ),
  );
}

Sequence _sampleSequence() {
  return Sequence(
    id: 1,
    title: '아침 활력 요가',
    description: '호흡과 중심 정렬에 집중합니다.',
    level: SequenceLevel.beginner,
    tags: const ['아침'],
    isFavorite: false,
    createdAt: DateTime(2026, 3, 20),
    updatedAt: DateTime(2026, 3, 23),
  );
}
