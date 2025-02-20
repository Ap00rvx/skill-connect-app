part of 'answer_bloc.dart';

@immutable
sealed class AnswerEvent {}
class GetAnswers extends AnswerEvent {
  final String questionId;
  GetAnswers(this.questionId);
}

class AddAnswer extends AnswerEvent {
  final String questionId;
  final String answer;
  AddAnswer(this.questionId, this.answer);
}