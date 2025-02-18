import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/cloudinary_service.dart';
import 'package:shatter_vcs/services/user_service.dart';

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
      getUnAnsweredQuestions() async {
    try {
      final response = await _firestore.collection('questions').get();

      final questions =
          response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();
      List<QuestionModel> unAnsweredQuestions =
          questions.where((q) => q.answers.isEmpty).toList();

      return left(unAnsweredQuestions);
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error fetching questions", 500));
    }
  }

  Future<Either<List<QuestionModel>, NetworkException>>
      getTopVotedQuestions() async {
    try {
      final response = await _firestore.collection('questions').get();
      // sort question according to the upvotes
      final questions =
          response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();

      questions.sort((a, b) => b.upvotes.compareTo(a.upvotes));

      return left(questions);
    } catch (e) {
      print("There is an error ---> " + e.toString());

      return right(NetworkException("Error fetching questions", 500));
    }
  }

  Future<Either<List<QuestionModel>, NetworkException>>
      getLatestQuestions() async {
    try {
      final response = await _firestore.collection('questions').get();
      // sort question according to the createAt
      final questions =
          response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();

      questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return left(questions);
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error fetching questions", 500));
    }
  }

  Future<Either<List<QuestionModel>, NetworkException>>
      getInterestQuestions() async {
    try {
      final response = await _firestore.collection('questions').get();
      final user = locator.get<UserService>().user!;

      // Normalize user interests (trim spaces & convert to lowercase)
      final userInterest =
          user.skills.map((e) => e.trim().toLowerCase()).toList();

      final questions =
          response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();

      List<QuestionModel> interestQuestions = [];

      for (var question in questions) {
        for (var tag in question.tags) {
          if (userInterest.contains(tag.trim().toLowerCase())) {
            interestQuestions.add(question);
            break; // Avoid adding the same question multiple times
          }
        }
      }

      if (userInterest.isEmpty) {
        return left(questions);
      }

      print(interestQuestions);
      return left(interestQuestions);
    } catch (e) {
      print("There is an error ---> " + e.toString());
      return right(NetworkException("Error fetching questions", 500));
    }
  }

  Future<Either<List<QuestionModel>, NetworkException>>
      getAllQuestions() async {
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
