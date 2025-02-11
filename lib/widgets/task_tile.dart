import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/todo/todo_bloc.dart';
import 'package:shatter_vcs/model/to_do_model.dart';
import 'package:shatter_vcs/screens/todo/to_do_page.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.todo});
  final Todo todo;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late bool isCompleted; // Task status

  @override
  void initState() {
    super.initState();
    isCompleted = widget.todo.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPressStart: (LongPressStartDetails details) {
          _showPopupMenu(context, details, todo);
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.grey.shade100,
          isThreeLine: false,

          // **Leading: Status Indicator**
          leading: Icon(
            FluentIcons.circle_24_filled,
            color: isCompleted ? Colors.green : Colors.orange,
          ),

          // **Title & Description**
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Text(
                todo.description,
                style: TextStyle(
                  fontSize: 14,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),

          // **Trailing: Delete Button**
          trailing: IconButton(
            onPressed: () => {
              showDeleteTodoSheet(todo, context),
            },
            icon: const Icon(FluentIcons.delete_24_regular, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void showDeleteTodoSheet(Todo todo, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(FluentIcons.delete_24_regular, color: Colors.red),
              title: const Text("Delete Task"),
              onTap: () {
                BlocProvider.of<TodoBloc>(context).add(DeleteTodo(todo));
                Navigator.pop(context);
                showSnackbar("Task Deleted", false, context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel_rounded, color: Colors.grey),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(
      BuildContext context, LongPressStartDetails details, Todo todo) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selectedValue = await showMenu<bool>(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx, // X position of tap
        details.globalPosition.dy +
            10, // Y position + padding for better visibility
        details.globalPosition.dx + 1,
        details.globalPosition.dy + 50,
      ),
      items: [
        _buildPopupMenuItem("Mark as Incomplete", false, Colors.orange),
        _buildPopupMenuItem("Mark as Completed", true, Colors.green),
      ],
    );

    if (selectedValue != null) {
      setState(() {
        print(todo.copyWith(isCompleted: selectedValue).toJson());
        BlocProvider.of<TodoBloc>(context).add(
          UpdateTodoStatus(
            todo.copyWith(isCompleted: selectedValue),
          ),
        );
        isCompleted = selectedValue;
        if (isCompleted) {
          showSnackbar("Woooohooo! Task Completed", false, context);
        }
      });
    }
  }

  // **Helper Function for Popup Items**
  PopupMenuItem<bool> _buildPopupMenuItem(
      String text, bool value, Color color) {
    return PopupMenuItem<bool>(
      value: value,
      child: Row(
        children: [
          Icon(FluentIcons.circle_24_filled, color: color, size: 14),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
