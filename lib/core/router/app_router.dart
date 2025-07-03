import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:law_app/core/router/route_config.dart';
import 'package:law_app/features/form/views/pdf_screen.dart';
import 'package:law_app/features/home/views/home_screen.dart';
import 'package:law_app/features/reminder/views/create_and_update_reminder_screen.dart';
import 'package:law_app/features/reminder/views/reminder_screen.dart';
import 'boxmain.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>();
final _shellNavigatorReminderKey = GlobalKey<NavigatorState>();
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithAppbar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: Routes.home,
                pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
                routes: [GoRoute(path: Routes.pdf, pageBuilder: (context, state) => NoTransitionPage(child: PDFScreen()))],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReminderKey,
            routes: [
              GoRoute(
                path: Routes.reminder,
                pageBuilder: (context, state) => NoTransitionPage(child: ReminderScreen()),
                routes: [
                  GoRoute(path: Routes.createOrUpdateReminder, pageBuilder: (context, state) => NoTransitionPage(child: CreateAndUpdateReminderScreen())),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

extension RouterHelperExtension on WidgetRef {
  goSubPath(String path, {Map<String, dynamic>? params}) {
    var url = read(appRouterProvider).state.uri;
    String currentPath = url.path;
    return read(appRouterProvider).go(Uri(path: "$currentPath/$path", queryParameters: params).toString());
  }
}
