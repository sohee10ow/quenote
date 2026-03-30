import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/init/app_startup_controller.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/home/application/home_providers.dart';
import 'package:quenote/features/home/domain/entities/home_overview.dart';
import 'package:quenote/features/settings/domain/entities/user_settings.dart';
import 'package:quenote/features/settings/domain/enums/app_plan_type.dart';
import 'package:quenote/features/settings/domain/enums/app_text_size.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';
import 'package:quenote/features/settings/domain/enums/share_format_type.dart';
import 'package:quenote/features/sequence/application/sequence_providers.dart';
import 'package:quenote/features/sequence/application/step_template_providers.dart';
import 'package:quenote/features/shell/presentation/app_shell_screen.dart';

void main() {
  testWidgets('앱 쉘이 홈 시퀀스 즐겨찾기 설정 4개 탭을 제공한다', (tester) async {
    final controller = _FakeUserSettingsController(
      const UserSettings(
        planType: AppPlanType.free,
        betaProOverrideEnabled: false,
        selectedTheme: AppThemeType.sage,
        textSize: AppTextSize.medium,
        defaultShareFormat: ShareFormatType.full,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSettingsControllerProvider.overrideWith(() => controller),
          homeOverviewProvider.overrideWith(
            (ref) async => const HomeOverview(
              hasSequences: false,
              favoriteSequences: <HomeSequenceSummary>[],
              recentSequences: <HomeSequenceSummary>[],
              recentCueNotes: <HomeRecentCueNoteSummary>[],
            ),
          ),
          sequenceListProvider.overrideWith((ref) async => const []),
          sequenceStepCountsProvider.overrideWith((ref) async => const {}),
          stepTemplateListProvider(null).overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          theme: AppTheme.fromType(AppThemeType.sage),
          home: const AppShellScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final bottomNav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    final labels = bottomNav.items.map((item) => item.label).toList();

    expect(bottomNav.items.length, 4);
    expect(labels, ['홈', '시퀀스', '즐겨찾기', '설정']);

    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).onTap!(
      1,
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      1,
    );
    expect(find.text('시퀀스'), findsAtLeastNWidgets(1));

    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).onTap!(
      2,
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      2,
    );
    expect(find.text('아직 저장된 템플릿이 없어요'), findsOneWidget);

    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).onTap!(
      3,
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      3,
    );
    expect(find.text('설정'), findsAtLeastNWidgets(1));
  });
}

class _FakeUserSettingsController extends UserSettingsController {
  _FakeUserSettingsController(this._initial);

  final UserSettings _initial;

  @override
  Future<UserSettings> build() async => _initial;
}
