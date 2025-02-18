import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/screens/home/home_page.dart';
import 'package:shatter_vcs/services/auth_service.dart';
import 'package:shatter_vcs/services/user_service.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/custom_route.dart';
import 'package:shatter_vcs/widgets/auth_validation.dart';

class LoadUserDetailsPage extends StatefulWidget {
  const LoadUserDetailsPage({super.key});

  @override
  State<LoadUserDetailsPage> createState() => _LoadUserDetailsPageState();
}

class _LoadUserDetailsPageState extends State<LoadUserDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            Navigator.pushAndRemoveUntil(
                context, createRoute(const HomePage()), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // **Loading Text**

                  Text(
                    'Loading User Details...',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UserFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/error.jpg",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),

                // **Loading Text**

                ElevatedButton(
                  onPressed: () async {
                    AuthService().signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        createRoute(const AuthValidation()),
                        (route) => false,
                      );
                    });
                  },
                  style: buttonStyle,
                  child: const Text("Login Again"),
                )
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
