import 'dart:convert';
import 'package:shatter_vcs/model/to_do_model.dart';
import 'package:shatter_vcs/services/local_storage_service.dart';
import 'package:intl/intl.dart';

class TodoService {
  final _storage = LocalStorageService();
  List<DateTime> generateDates() {
    return List.generate(8, (i) => DateTime.now().add(Duration(days: i - 2)));
  }
  Future<void> addTask(Todo todo) async {
    final tasks = await getToDoList(todo.date);
    tasks.add(todo);
    final stringList = tasks.map((task) => jsonEncode(task.toJson())).toList();

    final formattedDate = DateFormat('ddMMyy').format(todo.date);
    await _storage.saveList(formattedDate, stringList);
  }

  Future<void> updateStatus(Todo todo) async {
    final tasks = await getToDoList(todo.date);
    tasks.forEach((element) {
      if (element.title == todo.title) {
        element.isCompleted = todo.isCompleted;
      }
    });
    // Encode each task to a proper JSON string
    final stringList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    print("Saving tasks: $stringList"); // Debugging log

    final formattedDate = DateFormat('ddMMyy').format(todo.date);
    await _storage.saveList(formattedDate, stringList);
  }

  // Get the list of tasks for a specific date
  Future<List<Todo>> getToDoList(DateTime date) async {
    final formattedDate = DateFormat('ddMMyy').format(date);
    final list = await _storage.getList(formattedDate);
    try {
      return list.map((taskJson) {
        print("Decoding: $taskJson"); // Log each JSON string before decoding
        final decoded = jsonDecode(taskJson);
        print("Decoded: ${decoded}"); // Log each decoded JSON object
        return Todo.fromJson({
          'title': decoded['title'],
          'description': decoded['description'],
          'date': decoded['date'],
          'isCompleted': decoded['isCompleted'],
        });
      }).toList();
    } catch (e) {
      print("Error decoding tasks: $e");
      return [];
    }
  }
  Future<void> deleteTask(Todo todo) async {
    final tasks = await getToDoList(todo.date);
    tasks.removeWhere((element) => element.title == todo.title);
    final stringList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    final formattedDate = DateFormat('ddMMyy').format(todo.date);
    await _storage.saveList(formattedDate, stringList);
  }
}
