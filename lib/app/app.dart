import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'init/app_startup_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class QuenoteApp extends ConsumerWidget {
  const QuenoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeType = ref.watch(appThemeTypeProvider);
    final textScaleFactor = ref.watch(appTextScaleFactorProvider);

    return MaterialApp(
      title: '요가 큐 노트',
      theme: AppTheme.fromType(themeType),
      navigatorKey: router.navigatorKey,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: '/',
      builder: (context, child) {
        final routedChild = child ?? const SizedBox.shrink();
        final mediaQuery = MediaQuery.maybeOf(context);
        if (mediaQuery == null) {
          return routedChild;
        }

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: routedChild,
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
