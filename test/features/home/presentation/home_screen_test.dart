import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/home/application/home_providers.dart';
import 'package:quenote/features/home/domain/entities/home_overview.dart';
import 'package:quenote/features/home/presentation/home_screen.dart';
import 'package:quenote/features/sequence/domain/entities/sequence.dart';
import 'package:quenote/features/sequence/domain/enums/sequence_level.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  testWidgets('저장된 시퀀스가 없으면 빠른 노트 작성 카드를 노출하지 않는다', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        overview: const HomeOverview(
          hasSequences: false,
          favoriteSequences: <HomeSequenceSummary>[],
          recentSequences: <HomeSequenceSummary>[],
          recentCueNotes: <HomeRecentCueNoteSummary>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('빠른 노트 작성'), findsNothing);
    expect(find.text('시작해볼까요?'), findsOneWidget);
  });

  testWidgets('저장된 시퀀스가 있으면 빠른 노트 작성 카드를 노출한다', (tester) async {
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
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('빠른 노트 작성'), findsOneWidget);
    expect(find.text('시작해볼까요?'), findsNothing);
  });
}

Widget _buildTestApp({required HomeOverview overview}) {
  return ProviderScope(
    overrides: [homeOverviewProvider.overrideWith((ref) async => overview)],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: const HomeScreen(),
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
