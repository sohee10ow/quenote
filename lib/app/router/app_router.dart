import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../init/app_startup_controller.dart';
import '../../features/shell/presentation/app_shell_screen.dart';
import '../../features/sequence/presentation/args/sequence_route_args.dart';
import '../../features/sequence/presentation/screens/sequence_detail_screen.dart';
import '../../features/sequence/presentation/screens/sequence_editor_screen.dart';
import '../../features/sequence/presentation/screens/sequence_full_view_screen.dart';
import '../../features/sequence/presentation/screens/sequence_list_screen.dart';
import '../../features/sequence/presentation/screens/step_duplicate_target_screen.dart';
import '../../features/sequence/presentation/screens/step_detail_screen.dart';
import '../../features/sequence/presentation/screens/step_editor_screen.dart';
import '../../features/sequence/presentation/screens/step_reorder_screen.dart';
import '../../features/theme_selection/presentation/theme_selection_placeholder_screen.dart';
import '../../features/favorites/presentation/step_template_picker_screen.dart';
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
        final args = settings.arguments as SequenceEditorRouteArgs?;
        return _cupertino(SequenceEditorScreen(args: args), settings);
      case AppRoutes.sequenceList:
        return _cupertino(
          const SequenceListScreen(showBackButton: true),
          settings,
        );
      case AppRoutes.sequenceDetail:
        final args = settings.arguments as SequenceDetailRouteArgs;
        return _cupertino(
          SequenceDetailScreen(sequenceId: args.sequenceId),
          settings,
        );
      case AppRoutes.sequenceFullView:
        final args = settings.arguments as SequenceFullViewRouteArgs;
        return _cupertino(
          SequenceFullViewScreen(sequenceId: args.sequenceId),
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
          StepEditorScreen(
            sequenceId: args.sequenceId,
            stepId: args.stepId,
            templateId: args.templateId,
          ),
          settings,
        );
      case AppRoutes.stepTemplatePicker:
        return _cupertino(const StepTemplatePickerScreen(), settings);
      case AppRoutes.stepDuplicateTarget:
        final args = settings.arguments as StepDuplicateTargetRouteArgs;
        return _cupertino(
          StepDuplicateTargetScreen(
            sourceSequenceId: args.sourceSequenceId,
            sourceStepId: args.sourceStepId,
          ),
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
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('초기화에 실패했습니다.'),
                const SizedBox(height: 12),
                if (kDebugMode) ...[
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(userSettingsControllerProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
