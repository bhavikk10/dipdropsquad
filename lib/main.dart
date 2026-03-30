import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class ElasticScrollBehavior extends MaterialScrollBehavior {
  const ElasticScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // AlwaysScrollable ensures overscroll/bounce can happen even when content
    // doesn't fully exceed the viewport height.
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
      decelerationRate: ScrollDecelerationRate.fast,
    );
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    // Force the "rubber band" stretching effect even on platforms where Flutter defaults
    // to a non-stretch indicator (e.g., Windows desktop).
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      clipBehavior: Clip.none,
      child: child,
    );
  }
}

void main() {
  runApp(const ProviderScope(child: MyDipSquadApp()));
}

class MyDipSquadApp extends ConsumerWidget {
  const MyDipSquadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'MyDipSquad',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      scrollBehavior: const ElasticScrollBehavior(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
