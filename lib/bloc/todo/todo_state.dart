part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoSuccess extends TodoState {
  final List<Todo> todos;

  TodoSuccess(this.todos);
}

final class TodoFailure extends TodoState {
  final AppException exception;

  TodoFailure(this.exception);
}