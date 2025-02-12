import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/config/app_exception.dart';
import 'package:shatter_vcs/model/to_do_model.dart';
import 'package:shatter_vcs/services/todo_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<GetTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final tasks = await TodoService().getToDoList(event.date);

        emit(TodoSuccess(tasks));
      } on AppException catch (e) {
        emit(TodoFailure(e));
      }
    });
    on<AddTodo>(
      (event, emit) async {
        emit(TodoLoading());
        try {
          await TodoService().addTask(event.todo).then((_) {
            print('Task added');
            print(event.todo.toJson());
          });
          final tasks = await TodoService().getToDoList(event.todo.date);
          final todos = tasks;

          emit(TodoSuccess(todos));
        } on AppException catch (e) {
          emit(TodoFailure(e));
        }
      },
    );
    on<UpdateTodoStatus>(
      (event, emit) async {
        try {
          await TodoService().updateStatus(event.todo).then((_) {
            print('Task updated');
            print(event.todo.toJson());
          });
          final tasks = await TodoService().getToDoList(event.todo.date);
          final todos = tasks;

          emit(TodoSuccess(todos));
        } on AppException catch (e) {
          emit(TodoFailure(e));
        }
      },
    );
    on<DeleteTodo>(
      (event, emit) async {
        try {
          await TodoService().deleteTask(event.todo).then((_) {
            print('Task deleted');
            print(event.todo.toJson());
          });
          final todos = await TodoService().getToDoList(event.todo.date);
          emit(TodoSuccess(todos));
        } on AppException catch (e) {
          emit(TodoFailure(e));
        }
      },
    );
    on<FilterTodos>((event, emit) async {
      try {
        final date = event.date;
        if (event.isCompleted) {
          final tasks = await TodoService().filterCompletedTodos(date);
          emit(TodoSuccess(tasks));
        } else {
          final tasks = await TodoService().filterIncompletedTodos(date);
          emit(TodoSuccess(tasks));
        }
      } on AppException catch (e) {
        emit(TodoFailure(e));
      }
    });
  }
}
