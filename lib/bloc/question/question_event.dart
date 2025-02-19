part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

class CreateQuestion extends QuestionEvent {
  final QuestionModel question;
  final File? image;
  CreateQuestion(this.question, this.image);
}

// ignore: must_be_immutable
class GetQuestions extends QuestionEvent {
  final int index;
  GetQuestions({
    this.index = 2,
  });
}

final  class UpdateQuestionVote extends QuestionEvent {
  final QuestionModel question;
  final bool isUpVote; 
  UpdateQuestionVote(this.question, this.isUpVote);
}