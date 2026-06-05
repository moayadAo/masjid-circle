import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/shared/ui/error_page.dart';

import 'export_route_files.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splash,
    routes: [],
    errorBuilder: (context, state) =>
        const ErrorPage(message: 'حدث خطأ أثناء التنقل'),
    debugLogDiagnostics: true,
  );
}
