import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../init/app_startup_controller.dart';
import '../../features/shell/presentation/app_shell_screen.dart';
import '../../features/sequence/presentation/args/sequence_route_args.dart';
import '../../features/sequence/presentation/screens/sequence_detail_screen.dart';
import '../../features/sequence/presentation/screens/sequence_editor_screen.dart';
import '../../features/sequence/presentation/screens/sequence_list_screen.dart';
import '../../features/sequence/presentation/screens/step_detail_screen.dart';
import '../../features/sequence/presentation/screens/step_editor_screen.dart';
import '../../features/sequence/presentation/screens/step_reorder_screen.dart';
import '../../features/theme_selection/presentation/theme_selection_placeholder_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());

class AppRouter {
  final navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.themeSelection:
        return _cupertino(const ThemeSelectionPlaceholderScreen(), settings);
      case AppRoutes.shell:
        return _cupertino(const AppShellScreen(), settings);
      case AppRoutes.sequenceEditor:
        return _cupertino(const SequenceEditorScreen(), settings);
      case AppRoutes.sequenceList:
        return _cupertino(const SequenceListScreen(), settings);
      case AppRoutes.sequenceDetail:
        final args = settings.arguments as SequenceDetailRouteArgs;
        return _cupertino(
          SequenceDetailScreen(sequenceId: args.sequenceId),
          settings,
        );
      case AppRoutes.stepDetail:
        final args = settings.arguments as StepDetailRouteArgs;
        return _cupertino(
          StepDetailScreen(sequenceId: args.sequenceId, stepId: args.stepId),
          settings,
        );
      case AppRoutes.stepEditor:
        final args = settings.arguments as StepEditorRouteArgs;
        return _cupertino(
          StepEditorScreen(sequenceId: args.sequenceId, stepId: args.stepId),
          settings,
        );
      case AppRoutes.stepReorder:
        final args = settings.arguments as StepReorderRouteArgs;
        return _cupertino(
          StepReorderScreen(sequenceId: args.sequenceId),
          settings,
        );
      case AppRoutes.startup:
      default:
        return _cupertino(const _StartupGate(), settings);
    }
  }

  static CupertinoPageRoute<T> _cupertino<T>(
    Widget child,
    RouteSettings settings,
  ) {
    return CupertinoPageRoute<T>(builder: (_) => child, settings: settings);
  }
}

class _StartupGate extends ConsumerWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(userSettingsControllerProvider);

    return startup.when(
      data: (settings) {
        if (settings.onboardingCompleted) {
          return const AppShellScreen();
        }
        return const ThemeSelectionPlaceholderScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          const Scaffold(body: Center(child: Text('초기화에 실패했습니다.'))),
    );
  }
}
