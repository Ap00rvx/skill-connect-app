import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> signOut() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }
    await _firebase.signOut();
  }

  Future<Either<User, AppException>> signInWithGoogle() async {
    try {
      final credential = await _handleGoogleSignIn();
      if (credential != null) {
        final response = await _firebase.signInWithCredential(credential);
        if (response.user != null) {
          return left(response.user!);
        }
        return right(AppException("Error signing in user", "Credential"));
      }
      return right(AppException("Error signing in user", "Credential"));
    } on FirebaseAuthException catch (e) {
      return right(AppException(e.message!, e.credential.toString()));
    } catch (e) {
      return right(
          AppException("An unexpected error occurred: ${e.toString()}", ""));
    }
  }

  Future<OAuthCredential?> _handleGoogleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        return credential;
      }
    } catch (err) {
      print(err);
      return null;
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
