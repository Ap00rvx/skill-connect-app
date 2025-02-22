import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/question_service.dart';

class SearchService {
  final _questionCollections =
      FirebaseFirestore.instance.collection('questions');
  final _cacheService = locator.get<QuestionService>();

  Future<List<QuestionModel>> searchQuestions(String query) async {
    try {
      final lowerQuery = query.toLowerCase(); // Convert query to lowercase
      List<QuestionModel> questions = [];
      if (_cacheService.cachedQuestions.isEmpty) {
        final response = await _questionCollections.get();
        questions =
            response.docs.map((e) => QuestionModel.fromJson(e.data())).toList();
        _cacheService.cachedQuestions = questions;
      } else {
        questions = _cacheService.cachedQuestions;
        print("Using cached questions");
      }

      // perform search
      final results = questions
          .where((q) => q.title.toLowerCase().contains(lowerQuery))
          .toList();

      return results;
    } catch (err) {
      print(err);
      return [];
    }
  }
}
