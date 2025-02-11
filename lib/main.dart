import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/auth/auth_bloc.dart';
import 'package:shatter_vcs/bloc/todo/todo_bloc.dart';
import 'package:shatter_vcs/firebase_options.dart';
import 'package:shatter_vcs/widgets/auth_validation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    print('\x1B[36m App initialized \x1B[0m');
  });
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => TodoBloc())
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "default"),
        title: 'Shatter VCS',
        home: const AuthValidation(),
      ),
    );
  }
}
