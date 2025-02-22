part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<QuestionModel> questions;

  SearchSuccess(this.questions);
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}

