import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/auth/presentation/pages/login_page.dart';
import 'package:masjid/shared/ui/error_page.dart';

import 'export_route_files.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        pageBuilder: (context, state) =>
            fadeScaleTransitionPage(state, LoginPage()),
      ),
    ],

    errorBuilder: (context, state) =>
        const ErrorPage(message: 'حدث خطأ أثناء التنقل'),
    debugLogDiagnostics: true,
  );
}
