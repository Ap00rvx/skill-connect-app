import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shatter_vcs/config/app_exception.dart';
import 'package:shatter_vcs/model/user_model.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Either<User, AppException>> signUp(
      String email, String password, String name) async {
    try {
      final response = await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);

      if (response.user != null) {
        await response.user!.updateDisplayName(name);
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
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }

    if (_firebase != null) {
      await _firebase.signOut();
    } else {
      print("Firebase instance is null");
    }
  }

  Future<Either<User, AppException>> signInWithGoogle() async {
    try {
      final credential = await _handleGoogleSignIn();
      if (credential != null) {
        final response = await _firebase.signInWithCredential(credential);
        if (response.user != null) {
          final userData = await _firestore
              .collection('users')
              .doc(response.user!.uid)
              .get();

          if (userData.exists) {
            return left(response.user!);
          } else {
            final userModel = UserModel(
                id: response.user!.uid,
                email: response.user!.email!,
                name: response.user!.displayName!,
                profilePicture: response.user!.photoURL ?? "",
                joinedAt: DateTime.now());

            await _firestore
                .collection('users')
                .doc(response.user!.uid)
                .set(userModel.toJson());

            return left(response.user!);
          }
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
