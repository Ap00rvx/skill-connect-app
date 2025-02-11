import 'package:flutter/material.dart';

class CircularAvatarWrapper extends StatelessWidget {
  const CircularAvatarWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.blue[50]?.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue[100]?.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue[200]?.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: child),
        ));
  }
}
