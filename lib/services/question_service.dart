import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/cloudinary_service.dart';

class QuestionService {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<String, NetworkException>> saveQuestion(
      QuestionModel question, File? image) async {
    try {
      if (image != null) {
        final response = await CloudinaryService().uploadImage(image);
        response.fold(
            (url) => question.image = url, (exception) => right(exception));

        await _firestore
            .collection('questions')
            .doc(question.id)
            .set(question.toJson());
        return left("Question saved successfully");
      } else {
        await _firestore
            .collection('questions')
            .doc(question.id)
            .set(question.toJson());
        return left("Question saved successfully");
      }
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error saving question", 500));
    }
  }

  Future<Either<List<QuestionModel>, NetworkException>>
      getPersonalisedQuestions() async {
    try {
      final response = await _firestore.collection('questions').get();
      final questions =
          response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();
      return left(questions);
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error fetching questions", 500));
    }
  }
}
