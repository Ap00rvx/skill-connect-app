import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/todo/todo_bloc.dart';
import 'package:shatter_vcs/model/to_do_model.dart';
import 'package:shatter_vcs/screens/auth/auth_page.dart';
import 'package:shatter_vcs/services/auth_service.dart';
import 'package:shatter_vcs/services/todo_service.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';
import 'package:shatter_vcs/widgets/task_tile.dart';
import 'package:shimmer/shimmer.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final dates = TodoService().generateDates();
  final weekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TodoBloc>().add(GetTodos(selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text("Goal List"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    "Plan & Achieve",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // build a scrollable list of date from 5 days ago to 5 days ahead
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      //format using intl package

                      String date = dates[index].day.toString();
                      String day = weekdays[dates[index].weekday - 1];
                      String month = months[dates[index].month - 1];

                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedDate = dates[index];
                                context
                                    .read<TodoBloc>()
                                    .add(GetTodos(selectedDate));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selectedDate.day == dates[index].day
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                              foregroundColor:
                                  selectedDate.day == dates[index].day
                                      ? Colors.white
                                      : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$date-$month",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  day,
                                  style: const TextStyle(
                                    // color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildDailyAnalysis(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Day's Tasks",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: showAddTaskDialog,
                          icon: Icon(FluentIcons.add_24_regular)),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                _buildFilterChips(),

                const SizedBox(height: 10),

                _buildToDoList()
              ],
            ),
          ),
        ));
  }

  int selected = 0;

  Widget _buildFilterChips() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoSuccess) {
          return Wrap(
            children: [
              FilterChip(
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey.shade200,
                selected: selected == 0,
                label: const Text("All"),
                showCheckmark: false,
                onSelected: (selected) {
                  setState(() {
                    this.selected = 0;
                  });
                  context.read<TodoBloc>().add(GetTodos(selectedDate));
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey.shade200,
                selected: selected == 1,
                showCheckmark: false,
                label: const Text(
                  "Completed",
                ),
                onSelected: (selected) {
                  setState(() {
                    this.selected = 1;
                  });
                  context.read<TodoBloc>().add(FilterTodos(true, selectedDate));
                },
              ),
              const SizedBox(width: 10),
              FilterChip(
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey.shade200,
                selected: selected == 2,
                showCheckmark: false,
                label: const Text("Incomplete"),
                onSelected: (selected) {
                  setState(() {
                    this.selected = 2;
                  });
                  context
                      .read<TodoBloc>()
                      .add(FilterTodos(false, selectedDate));
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Adjusts height dynamically
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Add Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: customInputDecoration(
                  hintText: "Title",
                  prefixIcon: FluentIcons.text_bold_24_regular,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 5,
                decoration: customInputDecoration(
                  hintText: "Description",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(200, 50)),
                    onPressed: () {
                      final title = titleController.text;
                      final description = descriptionController.text;
                      if (title.isNotEmpty && description.isNotEmpty) {
                        final todo = Todo(
                          title: title,
                          description: description,
                          date: selectedDate,
                        );
                        context.read<TodoBloc>().add(AddTodo(todo));
                        // close sheet
                        Navigator.pop(context);
                      } else {
                        showSnackbar("Please fill all fields", true, context);
                      }
                    },
                    child: const Text("Add Task"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  final TodoService todoService = TodoService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Number of shimmering ListTiles
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
              ),
              title: Container(
                height: 16,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 12,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8.0),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyAnalysis() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return _buildLoadingShimmer();
        } else if (state is TodoSuccess) {
          final todos = state.todos;

          int completedTasks = todos.where((todo) => todo.isCompleted).length;
          int incompleteTasks = todos.length - completedTasks;

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Task Analysis",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildAnalysisRow("Total Tasks", todos.length, Colors.blue),
                    _buildAnalysisRow(
                        "Completed Tasks", completedTasks, Colors.green),
                    _buildAnalysisRow(
                        "Incomplete Tasks", incompleteTasks, Colors.orange),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text("No tasks to analyze"));
        }
      },
    );
  }

// Helper function to create an analysis row
  Widget _buildAnalysisRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Chip(
            label: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildToDoList() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return _buildLoadingShimmer();
        } else if (state is TodoSuccess) {
          final todos = state.todos;
          print(todos);
          if (todos.isEmpty) {
            final formattedDate =
                "${selectedDate.day}-${months[selectedDate.month - 1]}";
            return Column(
              children: [
                Center(
                  child: Text(
                      "No tasks for ${(selectedDate.day == DateTime.now().day) ? "Today" : formattedDate}"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: showAddTaskDialog,
                  child: const Text("Add Task"),
                  style: buttonStyle,
                ),
              ],
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];

              return TaskTile(todo: todo);
            },
          );
        } else {
          return const Center(
            child: Text("No tasks for today"),
          );
        }
      },
    );
  }
}
