part of 'answer_bloc.dart';



@immutable
sealed class AnswerState {}

final class AnswerInitial extends AnswerState {}

final class AnswerLoading extends AnswerState {}

final class AnswerSuccess extends AnswerState {
  final List<AnswerModel> answers;

  AnswerSuccess(this.answers);
}

final class AnswerFailure extends AnswerState {
  final NetworkException exception;

  AnswerFailure(this.exception);
}