part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUp(this.email, this.password, this.name);
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn(this.email, this.password);
}
final class AuthGoogleSignIn extends AuthEvent {}
final class AuthSignOut extends AuthEvent {}