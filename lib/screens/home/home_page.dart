import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shatter_vcs/screens/profile/profile_page.dart';
import 'package:shatter_vcs/screens/todo/to_do_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pages = const [
    Placeholder(),
    ToDoPage(),
    Placeholder(),
    ProfilePage(),
  ];
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: index,
        selectedLabelStyle:
            const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(FluentIcons.home_24_filled),
              icon: Icon(FluentIcons.home_24_regular),
              label: "Home"),
          BottomNavigationBarItem(
              activeIcon: Icon(FluentIcons.clipboard_task_list_rtl_24_filled),
              icon: Icon(FluentIcons.clipboard_task_list_rtl_24_regular),
              label: "Goal List"),
          BottomNavigationBarItem(
              activeIcon: Icon(FluentIcons.question_24_filled),
              icon: Icon(FluentIcons.question_24_regular),
              label: "Ask"),
          BottomNavigationBarItem(
            activeIcon: Icon(FluentIcons.person_24_filled),
            icon: Icon(FluentIcons.person_24_regular),
            label: "Profile",
          ),
        ],
      ),
      body: pages[index],
    );
  }
}
