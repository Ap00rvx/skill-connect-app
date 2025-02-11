part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class GetTodos extends TodoEvent {
  final DateTime date;

  GetTodos(this.date);
}

final class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo(this.todo);
}
final class UpdateTodoStatus extends TodoEvent {
  final Todo todo;

  UpdateTodoStatus(this.todo);
}

final class DeleteTodo extends TodoEvent {
  final Todo todo;

  DeleteTodo(this.todo);
}