import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/question_service.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionService _questionService = QuestionService();
  QuestionBloc() : super(QuestionInitial()) {
    on<CreateQuestion>((event, emit) async {
      emit(QuestionLoading());
      final question = event.question;
      final image = event.image;
      try {
        final response = await _questionService.saveQuestion(question, image);

        response.fold((message) => emit(QuestionSaved(question)),
            (exception) => emit(QuestionFailure(exception)));
      } catch (e) {
        print(e);
        emit(QuestionFailure(NetworkException("Error saving question", 500)));
      }
    });
    on<GetQuestions>((event, emit) async {
      emit(QuestionLoading());
      try {
        if (event.index == 0) {
          final response = await _questionService.getUnAnsweredQuestions();
          response.fold((questions) => emit(QuestionSuccess(questions)),
              (exception) => emit(QuestionFailure(exception)));
        } else if (event.index == 1) {
          final response = await _questionService.getTopVotedQuestions();
          response.fold((questions) => emit(QuestionSuccess(questions)),
              (exception) => emit(QuestionFailure(exception)));
        } else if (event.index == 3) {
          final response = await _questionService.getLatestQuestions();
          response.fold((questions) => emit(QuestionSuccess(questions)),
              (exception) => emit(QuestionFailure(exception)));
        } else if (event.index == 2) {
          final response = await _questionService.getInterestQuestions();
          response.fold((questions) => emit(QuestionSuccess(questions)),
              (exception) => emit(QuestionFailure(exception)));
        } else {
          // Handle unknown index values
          emit(QuestionFailure(NetworkException("Unknown index", 500)));
        }
      } catch (e) {
        print(e);
        emit(
            QuestionFailure(NetworkException("Error fetching questions", 500)));
      }
    });
  }
}
