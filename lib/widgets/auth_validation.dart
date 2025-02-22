import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/screens/auth/auth_page.dart';
import 'package:shatter_vcs/screens/auth/load_user_details_page.dart';
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
            print(
                '\x1B[36m Welcome back !! ${snapshot.data!.displayName} \x1B[0m');
            
            return const HomePage();
          }
          return const AuthPage();
        });
  }
}
