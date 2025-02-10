import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/config/app_exception.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;

  Future<Either<User, AppException>> signUp(
      String email, String password, String name) async {
    try {
      final response = await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);

      if (response.user != null) {
        response.user!.updateDisplayName(name);
        return left(response.user!);
      }

      return right(AppException("Error signing up user", "Credential"));
    } on FirebaseAuthException catch (e) {
    
      return right(AppException(e.message!, e.credential.toString()));
    } catch (e) {
      return right(
          AppException("An unexpected error occurred: ${e.toString()}", ""));
    }
  }

  Future<Either<User, AppException>> login(
      String email, String password) async {
    try {
      final response = await _firebase.signInWithEmailAndPassword(
          email: email, password: password); 
      if (response.user != null) {
        return left(response.user!);
      }

      return right(AppException("Error Signing in user", "Credential"));
    } on FirebaseAuthException catch (e) {
      return right(AppException(e.message!, e.credential.toString()));
    }
  }
}
