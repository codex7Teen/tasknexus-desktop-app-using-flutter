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
  static Future<T?> navigateToWithoutReplacement<T>(
    BuildContext context,
    Widget page, {
    int transitionDuration = 350,
  }) async {
    return await Navigator.of(context).push<T>(
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
