part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

class CreateQuestion extends QuestionEvent {
  final QuestionModel question;
  final File? image;  
  CreateQuestion(this.question, this.image);
}
