import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


/////////////////////////////////////////////////////////////////////////////////////////////
///************************** THIS FOR Splash / Onboarding / Login / Register
/////////////////////////////////////////////////////////////////////////////////////////////
CustomTransitionPage fadeScaleTransitionPage(
    GoRouterState state,
    Widget child,
    ) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    child: child,
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}



/////////////////////////////////////////////////////////////////////////////////////////////
///************************** THIS FOR Home → Details → Deep details
/////////////////////////////////////////////////////////////////////////////////////////////


CustomTransitionPage slideTransitionPage(
    GoRouterState state,
    Widget child,
    ) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      final isRtl = Directionality.of(context) == TextDirection.rtl;

      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(isRtl ? -1 : 1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
