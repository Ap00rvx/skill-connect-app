import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/model/user_model.dart';
import 'package:shatter_vcs/services/cloudinary_service.dart';

class UserService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Either<String, NetworkException>> saveUserDetails(
      UserModel user, File? image) async {
    final userId = _firebaseAuth.currentUser!.uid;
    if (image != null) {
      final response = await CloudinaryService().uploadImage(image);
      response.fold(
          (url) => user.profilePicture = url, (exception) => right(exception));
    }
    print(user.toJson());

    try {
      await _firestore.collection('users').doc(userId).set(user.toJson());
      return left("User details saved successfully");
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error saving user details", 500));
    }
  }
  Future<Either<UserModel, NetworkException>> getUserDetails() async {
    final userId = _firebaseAuth.currentUser!.uid;
    try {
      final response =
          await _firestore.collection('users').doc(userId).get();
      if (response.exists) {
        final user = UserModel.fromJson(response.data()!);
        return left(user);
      }
      return right(NetworkException("User not found", 404));
    } catch (e) {
      return right(NetworkException("Error fetching user details", 500));
    }
  }
}
