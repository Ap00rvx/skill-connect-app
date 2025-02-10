import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shatter_vcs/screens/auth/auth_page.dart';
import 'package:shatter_vcs/screens/home/home_page.dart';

class AuthValidation extends StatefulWidget {
  const AuthValidation({super.key});

  @override
  State<AuthValidation> createState() => _AuthValidationState();
}

class _AuthValidationState extends State<AuthValidation> {
  final _firebase = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebase.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const AuthPage();
        });
  }
}
