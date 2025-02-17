import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/main.dart';
import 'package:shatter_vcs/screens/engage_section/engage_page.dart';
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
    EngagePage(),
    ProfilePage(),
  ];
  int index = 2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserBloc>().add(GetUserDetails());
  }

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
              label: "Engage"),
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
