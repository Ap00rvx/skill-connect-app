import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/config/network_exception.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/question_service.dart';

part 'answer_event.dart';
part 'answer_state.dart';

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  AnswerBloc() : super(AnswerInitial()) {
    final _questionService = QuestionService();
    on<GetAnswers>((event, emit) async {
      emit(AnswerLoading());
      try {
        final response = await _questionService.getAnswers(event.questionId);
        response.fold((answers) => emit(AnswerSuccess(answers)),
            (exception) => emit(AnswerFailure(exception)));
      } catch (e) {
        print(e);
        emit(AnswerFailure(NetworkException("Error fetching answers", 500)));
      }
    });


    on<AddAnswer>((event, emit) async {
      emit(AnswerLoading());
      try {
        final response = await _questionService.saveAnswer(event.questionId, event.answer);
        response.fold((answers ) => emit(AnswerSuccess(answers)),
            (exception) => emit(AnswerFailure(exception)));
      } catch (e) {
        print(e);
        emit(AnswerFailure(NetworkException("Error adding answer", 500)));
      }
    });
  }


}
