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
  }
}
