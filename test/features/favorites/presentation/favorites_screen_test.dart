import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/favorites/presentation/favorites_screen.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/data/repositories/sequence_repository.dart';
import 'package:quenote/features/sequence/domain/entities/breath_cue_entry.dart';
import 'package:quenote/features/sequence/domain/entities/step_template.dart';
import 'package:quenote/features/sequence/domain/enums/side_type.dart';
import 'package:quenote/features/sequence/domain/enums/step_template_category.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';

void main() {
  testWidgets('저장된 템플릿이 없으면 빈 상태를 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(templates: const []);

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('즐겨찾기'), findsOneWidget);
    expect(find.text('아직 저장된 템플릿이 없어요'), findsOneWidget);
    expect(
      find.text('시퀀스 안의 동작 상세에서 `즐겨찾기에 저장`을 누르면 여기에 모아둘 수 있어요.'),
      findsOneWidget,
    );
  });

  testWidgets('카테고리를 선택하면 해당 템플릿만 보여준다', (tester) async {
    final repository = _FakeSequenceRepository(
      templates: [_warmupTemplate(), _cooldownTemplate()],
    );

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('고양이 소 자세'), findsOneWidget);
    expect(find.text('누운 트위스트'), findsOneWidget);

    await tester.tap(find.text('시작 스트레칭').first);
    await tester.pumpAndSettle();

    expect(find.text('고양이 소 자세'), findsOneWidget);
    expect(find.text('누운 트위스트'), findsNothing);
  });

  testWidgets('템플릿 카드 탭 시 미리보기 시트가 열린다', (tester) async {
    final repository = _FakeSequenceRepository(templates: [_warmupTemplate()]);

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('고양이 소 자세'));
    await tester.pumpAndSettle();

    expect(find.text('준비동작 큐잉'), findsOneWidget);
    expect(find.text('템플릿 삭제'), findsOneWidget);
  });

  testWidgets('템플릿 삭제를 확인하면 저장소 삭제를 호출한다', (tester) async {
    final repository = _FakeSequenceRepository(templates: [_warmupTemplate()]);

    await tester.pumpWidget(
      _buildTestApp(repository: repository, child: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('고양이 소 자세'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('템플릿 삭제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제'));
    await tester.pumpAndSettle();

    expect(repository.deleteTemplateCallCount, 1);
    expect(repository.lastDeletedTemplateId, 1);
    expect(find.text('아직 저장된 템플릿이 없어요'), findsOneWidget);
  });
}

Widget _buildTestApp({
  required SequenceRepository repository,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [sequenceRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: child,
    ),
  );
}

StepTemplate _warmupTemplate() {
  return StepTemplate(
    id: 1,
    category: StepTemplateCategory.warmup,
    poseName: '고양이 소 자세',
    sanskritName: null,
    sideType: SideType.none,
    isBalancePose: false,
    breathCount: 2,
    preparationCue: '네발 자세에서 시작합니다.',
    breathCues: const [
      BreathCueEntry(breathIndex: 1, text: '들이마시며 가슴을 엽니다.'),
      BreathCueEntry(breathIndex: 2, text: '내쉬며 등을 둥글게 말아줍니다.'),
    ],
    releaseCue: '중립 척추로 돌아옵니다.',
    cautionNote: null,
    beginnerModificationNote: null,
    imagePaths: const [],
    createdAt: DateTime(2026, 3, 20),
    updatedAt: DateTime(2026, 3, 20),
  );
}

StepTemplate _cooldownTemplate() {
  return StepTemplate(
    id: 2,
    category: StepTemplateCategory.cooldown,
    poseName: '누운 트위스트',
    sanskritName: null,
    sideType: SideType.both,
    isBalancePose: false,
    breathCount: 3,
    preparationCue: '등을 대고 눕습니다.',
    breathCues: const [
      BreathCueEntry(breathIndex: 1, text: '무릎을 가슴 쪽으로 당깁니다.'),
      BreathCueEntry(breathIndex: 2, text: '무릎을 오른쪽으로 넘깁니다.'),
      BreathCueEntry(breathIndex: 3, text: '반대쪽도 반복합니다.'),
    ],
    releaseCue: '무릎을 다시 가운데로 가져옵니다.',
    cautionNote: null,
    beginnerModificationNote: null,
    imagePaths: const [],
    createdAt: DateTime(2026, 3, 20),
    updatedAt: DateTime(2026, 3, 21),
  );
}

class _FakeSequenceRepository extends SequenceRepository {
  _FakeSequenceRepository({required List<StepTemplate> templates})
    : _templates = List<StepTemplate>.from(templates),
      super(_unsupportedRead);

  final List<StepTemplate> _templates;
  int deleteTemplateCallCount = 0;
  int? lastDeletedTemplateId;

  static T _unsupportedRead<T>(ProviderListenable<T> provider) {
    throw UnimplementedError();
  }

  @override
  Future<List<StepTemplate>> fetchStepTemplates({
    StepTemplateCategory? category,
  }) async {
    return _templates
        .where((template) {
          return category == null || template.category == category;
        })
        .toList(growable: false);
  }

  @override
  Future<void> deleteStepTemplate(int templateId) async {
    deleteTemplateCallCount += 1;
    lastDeletedTemplateId = templateId;
    _templates.removeWhere((template) => template.id == templateId);
  }
}
