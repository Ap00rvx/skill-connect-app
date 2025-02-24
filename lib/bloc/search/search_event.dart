part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class SearchSubmitted extends SearchEvent {
  final String query;

  SearchSubmitted(this.query);
}


