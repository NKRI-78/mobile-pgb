import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PageTransitionType { fade, slide, scale, rotation, fadeSlide }

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  PageTransitionType transitionType = PageTransitionType.fade,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);

        case PageTransitionType.slide:
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
              position: animation.drive(tween), child: child);

        case PageTransitionType.scale:
          return ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: child,
          );

        case PageTransitionType.rotation:
          return RotationTransition(turns: animation, child: child);

        case PageTransitionType.fadeSlide:
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          return FadeTransition(
            opacity: animation,
            child:
                SlideTransition(position: animation.drive(tween), child: child),
          );
      }
    },
  );
}
