import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/question/question_bloc.dart';
import 'package:shatter_vcs/screens/engage_section/add_question_page.dart';
import 'package:shatter_vcs/screens/engage_section/questions_section.dart';
import 'package:shatter_vcs/theme/style/custom_route.dart';

class EngagePage extends StatefulWidget {
  const EngagePage({super.key});

  @override
  State<EngagePage> createState() => _EngagePageState();
}

class _EngagePageState extends State<EngagePage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  int index = 2;
  late final TabController _tabController =
      TabController(length: 4, vsync: this, initialIndex: 2);

  final tabs = const [
    Tab(
      text: "UnAnswered",
    ),
    Tab(
      text: "Top Voted",
    ),
    Tab(
      text: 'Your Interests',
    ),
    Tab(
      text: "Latest",
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
    BlocProvider.of<QuestionBloc>(context).add(GetQuestions(
      index: index,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: false,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(FluentIcons.filter_24_regular),
                onPressed: () {},
              )
            ],
            leading: IconButton(
              icon: Icon(FluentIcons.add_24_regular),
              onPressed: () {
                Navigator.of(context)
                    .push(createRoute(const AddQuestionPage()));
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Align(
                alignment: Alignment.center, // Align tab bar properly
                child: TabBar(
                  onTap: (index) {
                    print(index);
                    // print current state
                    print(BlocProvider.of<QuestionBloc>(context).state);
                    BlocProvider.of<QuestionBloc>(context).add(GetQuestions(
                      index: index,
                    ));
                  },
                  controller: _tabController,
                  dragStartBehavior: DragStartBehavior.start,
                  isScrollable: false,
                  tabs: tabs,
                  indicatorColor: Colors.blue,
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade100,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade100,
                      width: 0,
                    ),
                  ),
                  hintText: 'Search',
                  prefixIcon: const Icon(
                    FluentIcons.search_16_regular,
                  ),
                ),
              ),
            ),
          ),
          const QuestionsSection(),
        ],
      ),
    );
  }
}
