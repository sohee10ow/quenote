import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/app/init/app_startup_controller.dart';
import 'package:quenote/app/theme/app_theme.dart';
import 'package:quenote/features/settings/domain/entities/user_settings.dart';
import 'package:quenote/features/settings/domain/enums/app_text_size.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';
import 'package:quenote/features/settings/domain/enums/share_format_type.dart';
import 'package:quenote/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('설정 화면이 현재 값과 섹션을 보여준다', (tester) async {
    final controller = _FakeUserSettingsController(
      const UserSettings(
        selectedTheme: AppThemeType.sage,
        textSize: AppTextSize.medium,
        defaultShareFormat: ShareFormatType.full,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_buildTestApp(controller));
    await tester.pumpAndSettle();

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('화면 및 디자인'), findsOneWidget);
    expect(find.text('데이터 및 공유'), findsOneWidget);
    expect(find.text('앱 정보'), findsOneWidget);
    expect(find.text('세이지 그린'), findsOneWidget);
    expect(find.text('보통'), findsOneWidget);
    expect(find.text('전체 시퀀스'), findsOneWidget);
    expect(find.text('최신 버전 (1.0.0)'), findsOneWidget);
  });

  testWidgets('앱 테마 row에서 샌드 베이지를 선택하면 설정이 갱신된다', (tester) async {
    final controller = _FakeUserSettingsController(
      const UserSettings(
        selectedTheme: AppThemeType.sage,
        textSize: AppTextSize.medium,
        defaultShareFormat: ShareFormatType.full,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_buildTestApp(controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('앱 테마'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('샌드 베이지'));
    await tester.pumpAndSettle();

    expect(controller.lastTheme, AppThemeType.sand);
    expect(find.text('샌드 베이지'), findsOneWidget);
  });

  testWidgets('요가 시퀀스 내보내기 row를 누르면 안내 스낵바가 보인다', (tester) async {
    final controller = _FakeUserSettingsController(
      const UserSettings(
        selectedTheme: AppThemeType.sage,
        textSize: AppTextSize.medium,
        defaultShareFormat: ShareFormatType.full,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_buildTestApp(controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('요가 시퀀스 내보내기'));
    await tester.pumpAndSettle();

    expect(find.text('내보내기 기능은 준비 중입니다.'), findsOneWidget);
  });
}

Widget _buildTestApp(_FakeUserSettingsController controller) {
  return ProviderScope(
    overrides: [userSettingsControllerProvider.overrideWith(() => controller)],
    child: MaterialApp(
      theme: AppTheme.fromType(AppThemeType.sage),
      home: const SettingsScreen(),
    ),
  );
}

class _FakeUserSettingsController extends UserSettingsController {
  _FakeUserSettingsController(this._initial);

  final UserSettings _initial;
  AppThemeType? lastTheme;
  AppTextSize? lastTextSize;
  ShareFormatType? lastShareFormat;

  @override
  Future<UserSettings> build() async => _initial;

  @override
  Future<void> setTheme(AppThemeType theme) async {
    lastTheme = theme;
    final next = state.requireValue.copyWith(selectedTheme: theme);
    state = AsyncData(next);
  }

  @override
  Future<void> setTextSize(AppTextSize textSize) async {
    lastTextSize = textSize;
    final next = state.requireValue.copyWith(textSize: textSize);
    state = AsyncData(next);
  }

  @override
  Future<void> setShareFormat(ShareFormatType shareFormat) async {
    lastShareFormat = shareFormat;
    final next = state.requireValue.copyWith(defaultShareFormat: shareFormat);
    state = AsyncData(next);
  }
}
