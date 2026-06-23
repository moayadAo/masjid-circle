import 'package:flutter/material.dart';
import 'package:masjid/core/storage/hive_boxes.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/storage/hive_key.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details_page.dart';
import 'package:masjid/feature/circles/presentation/pages/my_circles_page.dart';
import 'package:masjid/feature/home/assistant_home_page.dart';
import 'package:masjid/feature/attendance/presentation/pages/attendance_session_page.dart';
import 'package:masjid/feature/auth/presentation/pages/login_page.dart';
import 'package:masjid/feature/recitation/data/models/student_lookup_model.dart';
import 'package:masjid/feature/recitation/presentation/pages/recitation_page_main_nav.dart';
import 'package:masjid/feature/recitation_form/presentation/pages/recitation_form_page.dart';
import 'package:masjid/feature/splash/presentation/pages/splash_page.dart';
import 'package:masjid/feature/student_profile/presentation/pages/student_profile_page.dart';
import 'package:masjid/routing/export_route_files.dart';
import 'package:masjid/shared/ui/error_page.dart';

import '../feature/recitation/presentation/pages/recitation_page.dart';
export 'package:go_router/go_router.dart';
export 'routes.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splash,
    redirect: _roleGuard,
    routes: [
      // ── Splash ──────────────────────────────────────────────────
      GoRoute(
        path: Routes.splash,
        name: Routes.splash,
        pageBuilder: (ctx, state) => _fade(state, const SplashPage()),
      ),

      // ── Auth ─────────────────────────────────────────────────
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        pageBuilder: (ctx, state) => _fade(state, const LoginPage()),
      ),

      GoRoute(
        path: Routes.studentProfile,
        name: Routes.studentProfile,
        pageBuilder: (ctx, state) {
          final studentId = int.parse(state.pathParameters['studentId']!);
          return _slide(state, StudentProfilePage(studentId: studentId));
        },
      ),

      // ── Main Teacher ─────────────────────────────────────────
      GoRoute(
        path: Routes.myCircles,
        name: Routes.myCircles,
        pageBuilder: (ctx, state) => _fade(state, const MyCirclesPage()),
        routes: [
          GoRoute(
            path: ':circleId',
            name: Routes.circleDetails,
            pageBuilder: (ctx, state) {
              final circleId = int.parse(state.pathParameters['circleId']!);
              final circleName = state.extra is String
                  ? state.extra as String
                  : state.uri.queryParameters['name'] ?? '';
              return _slide(
                state,
                CircleDetailsPage(circleId: circleId, circleName: circleName),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.attendanceSession,
        name: Routes.attendanceSession,
        pageBuilder: (ctx, state) {
          final sessionId = int.parse(state.pathParameters['sessionId']!);
          return _slide(state, AttendanceSessionPage(sessionId: sessionId));
        },
      ),

      // ── Assistant ────────────────────────────────────────────
      GoRoute(
        path: Routes.assistantHome,
        name: Routes.assistantHome,
        pageBuilder: (ctx, state) => _fade(state, const AssistantHomePage()),
      ),
      GoRoute(
        path: Routes.generalRecitation,
        name: Routes.generalRecitation,
        pageBuilder: (context, state) =>
            fadeScaleTransitionPage(state, const RecitationPage()),
      ),
      GoRoute(
        path: Routes.generalRecitationMain,
        name: Routes.generalRecitationMain,
        pageBuilder: (context, state) =>
            fadeScaleTransitionPage(state, const RecitationPageMainNav()),
      ),
      GoRoute(
        path: Routes.recitationForm,
        name: Routes.recitationForm,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return _fade(
            state,
            RecitationFormPage(
              studentId: data['studentId'],
              studentName: data['studentName'],
              circleId: data['circleId'],
              cycleId: data['cycleId'],
            ),
          );
        },
      ),
    ],
    errorBuilder: (ctx, state) =>
        const ErrorPage(message: 'حدث خطأ أثناء التنقل'),
    debugLogDiagnostics: true,
  );

  // ── Role guard: redirect unauthenticated / wrong role ────────
  static Future<String?> _roleGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final hive = getIt<HiveHelper>();
    final token =
        await hive.getData(HiveBoxes.appBox, HiveKey.token) as String?;
    final role =
        await hive.getData(HiveBoxes.appBox, HiveKey.userRole) as String?;

    final isOnSplash = state.matchedLocation == Routes.splash;
    final isOnLogin = state.matchedLocation == Routes.login;

    // Allow splash screen to always show
    if (isOnSplash) {
      return null;
    }

    // Not logged in → force login
    if (token == null || token.isEmpty) {
      return isOnLogin ? null : Routes.login;
    }
    // ! REMOVE COMMENT
    // Already logged in and on login page → redirect by role
    if (isOnLogin) {
      return _homeByRole(role);
    }

    return null; // allow navigation
  }

  static String _homeByRole(String? role) {
    if (role == 'assistant') {
      return Routes
          .generalRecitation; //change it to generalRecitation because this is the assitance home
    }
    return Routes.myCircles; // default: main teacher
  }

  // ── Page transitions ─────────────────────────────────────────
  static CustomTransitionPage _fade(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, anim, __, c) =>
          FadeTransition(opacity: anim, child: c),
    );
  }

  static CustomTransitionPage _slide(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, anim, __, c) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: c,
      ),
    );
  }
}
