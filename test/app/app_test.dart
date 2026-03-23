import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quenote/app/app.dart';
import 'package:quenote/app/init/app_startup_controller.dart';
import 'package:quenote/app/router/app_router.dart';
import 'package:quenote/features/settings/domain/entities/user_settings.dart';
import 'package:quenote/features/settings/domain/enums/app_text_size.dart';
import 'package:quenote/features/settings/domain/enums/app_theme_type.dart';
import 'package:quenote/features/settings/domain/enums/share_format_type.dart';

void main() {
  testWidgets('텍스트 크기 설정이 앱 전역 MediaQuery에 반영된다', (tester) async {
    final controller = _FakeUserSettingsController(
      const UserSettings(
        selectedTheme: AppThemeType.sage,
        textSize: AppTextSize.large,
        defaultShareFormat: ShareFormatType.full,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSettingsControllerProvider.overrideWith(() => controller),
          appRouterProvider.overrideWithValue(_FakeAppRouter()),
        ],
        child: const QuenoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('11.0'), findsOneWidget);
  });
}

class _FakeAppRouter extends AppRouter {
  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        body: Builder(
          builder: (context) {
            final scaled = MediaQuery.textScalerOf(context).scale(10);
            return Center(child: Text(scaled.toStringAsFixed(1)));
          },
        ),
      ),
    );
  }
}

class _FakeUserSettingsController extends UserSettingsController {
  _FakeUserSettingsController(this._initial);

  final UserSettings _initial;

  @override
  Future<UserSettings> build() async => _initial;
}
