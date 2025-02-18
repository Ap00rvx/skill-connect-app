import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/auth/auth_bloc.dart';
import 'package:shatter_vcs/screens/auth/load_user_details_page.dart';
import 'package:shatter_vcs/screens/auth/user_details_page.dart';
import 'package:shatter_vcs/screens/home/home_page.dart';
import 'package:shatter_vcs/screens/static/terms_policy_page.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
      TextEditingController();
  final TextEditingController _signUpNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _submitLogin() {
    if (_formKeyLogin.currentState!.validate()) {
      final email = _loginEmailController.text;
      final password = _loginPasswordController.text;

      context.read<AuthBloc>().add(AuthSignIn(email, password));
    }
  }

  void _handleGoogleAuth() async {
    context.read<AuthBloc>().add(AuthGoogleSignIn());
  }

  bool isSignUp = false;

  void _submitSignUp() {
    if (_formKeySignUp.currentState!.validate()) {
      final email = _signUpEmailController.text;
      final password = _signUpPasswordController.text;
      final name = _signUpNameController.text;
      isSignUp = true;

      context.read<AuthBloc>().add(AuthSignUp(email, password, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.bottomStart,
      persistentFooterButtons: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsPolicyPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RichText(
                text: const TextSpan(
                  text: "By continuing, you agree to our ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Terms & Privacy Policy",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            Navigator.pop(context);
            showSnackbar(state.exception.message, true, context);
          }
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AuthSignUpSuccess) {
            isSignUp = true;
            Navigator.pop(context);
            showSnackbar('Welcome, ${state.user.email}!', false, context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserDetailsPage()),
            );
          }
          if (state is AuthSuccess) {
            Navigator.pop(context);
            showSnackbar('Welcome, ${state.user.email}!', false, context);

            if (!isSignUp) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage()),
                (route) => false,
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Image.asset("assets/images/logo.png", height: 200),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Where skills ignite opportunities and growth knows no bounds.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Tab Bar for Switching
                TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Login"),
                    Tab(text: "Sign Up"),
                  ],
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(),
                      _buildSignUpForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _loginEmailController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Email', prefixIcon: Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loginPasswordController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Password', prefixIcon: Icons.lock),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: buttonStyle,
              onPressed: _submitLogin,
              child: const Text('Login', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: _handleGoogleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                  fixedSize: const Size(double.infinity, 50),
                  minimumSize: const Size(400, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 34,
                      width: 34,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    const Text('Continue with Google',
                        style: TextStyle(fontSize: 18)),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // Signup Form
  Widget _buildSignUpForm() {
    return Form(
      key: _formKeySignUp,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _signUpNameController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Name', prefixIcon: Icons.person),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _signUpEmailController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Email', prefixIcon: Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signUpPasswordController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Password', prefixIcon: Icons.lock),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signUpConfirmPasswordController,
              cursorColor: Colors.blue,
              decoration: customInputDecoration(
                  hintText: 'Confirm Password', prefixIcon: Icons.lock),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != _signUpPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: buttonStyle,
              onPressed: _submitSignUp,
              child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: _handleGoogleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  textStyle: const TextStyle(fontSize: 16),
                  fixedSize: const Size(double.infinity, 50),
                  minimumSize: const Size(400, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 34,
                      width: 34,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    const Text('Continue with Google',
                        style: TextStyle(fontSize: 18)),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
