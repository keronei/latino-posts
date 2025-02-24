import 'package:flutter/cupertino.dart';

PageRoute customPageRoute(
  Widget page,
  RouteSettings settings,
  bool fromBottom,
) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: fromBottom ? Offset(0.0, 1.0) : Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: Duration(milliseconds: 750),
  );
}
