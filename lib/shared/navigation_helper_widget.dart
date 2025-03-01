import 'package:flutter/material.dart';

class NavigationHelper {
  //! SMOOTH PUSH NAVIGATION
  static void navigateToWithReplacement(
    BuildContext context,
    Widget page, {
    int milliseconds = 350,
  }) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: milliseconds),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  //! SMOOTH PUSH REPLACEMENT NAVIGATION
  static void navigateToWithoutReplacement(
    BuildContext context,
    Widget page, {
    int transitionDuration = 350,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: transitionDuration),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
