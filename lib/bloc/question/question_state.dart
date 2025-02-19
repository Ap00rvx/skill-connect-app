part of 'question_bloc.dart';

@immutable
sealed class QuestionState {}

final class QuestionInitial extends QuestionState {}

final class QuestionLoading extends QuestionState {}

final class QuestionSuccess extends QuestionState {
  final List<QuestionModel> questions;

  QuestionSuccess(this.questions);
}

final class QuestionFailure extends QuestionState {
  final NetworkException exception;

  QuestionFailure(this.exception);
}


final class QuestionSaved extends QuestionState {
  final QuestionModel question;

  QuestionSaved(this.question);
}
