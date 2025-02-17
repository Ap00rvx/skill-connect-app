import 'package:flutter/material.dart';

Route createRoute( Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500), // Animation speed
    pageBuilder: (context, animation, secondaryAnimation) => page ,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start from bottom
      const end = Offset.zero; // Move to normal position
      const curve = Curves.easeInOut; // Smooth easing

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0); // Fade effect

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
  );
}