import 'package:card_storage/src/pages/card/create_card_page.dart';
import 'package:card_storage/src/pages/card/edit_card_page.dart';
import 'package:card_storage/src/pages/card/list_card_page.dart';
import 'package:card_storage/src/pages/card/scan_barcode_page.dart';
import 'package:card_storage/src/pages/card/view_card_page.dart';
import 'package:card_storage/src/pages/main_page.dart';
import 'package:card_storage/src/pages/settings/settings_page.dart';
import 'package:card_storage/src/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

const _appTitle = 'Card Storage';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final normalizedPath = AppRoutes.normalize(state.uri.path);
      return normalizedPath == state.uri.path ? null : normalizedPath;
    },
    routes: [
      GoRoute(
        path: AppRoutes.cardList,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ListCardPage()),
      ),
      GoRoute(
        path: AppRoutes.cardCreate,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CreateCardPage()),
      ),
      GoRoute(
        path: AppRoutes.cardScan,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ScanBarcodePage()),
      ),
      GoRoute(
        path: AppRoutes.cardView,
        pageBuilder: (context, state) {
          final barcode = state.uri.queryParameters['barcode'];

          if (barcode == null || barcode.isEmpty) {
            return const NoTransitionPage(child: ListCardPage());
          }

          return NoTransitionPage(
            child: ViewCardPage(
              barcode: barcode,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cardEdit,
        pageBuilder: (context, state) {
          final barcode = state.uri.queryParameters['barcode'];

          if (barcode == null || barcode.isEmpty) {
            return const NoTransitionPage(child: ListCardPage());
          }

          return NoTransitionPage(
            child: EditCardPage(
              barcode: barcode,
            ),
          );
        },
      ),
      ShellRoute(
        pageBuilder: (context, state, child) {
          final routeName = AppRoutes.normalize(state.uri.path);

          return NoTransitionPage(
            child: MainPage(
              title: _appTitle,
              routeName: routeName,
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ListCardPage()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
    ],
  );
}
