import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/question/question_bloc.dart';
import 'package:shatter_vcs/bloc/search/search_bloc.dart';
import 'package:shatter_vcs/screens/engage_section/add_question_page.dart';
import 'package:shatter_vcs/screens/engage_section/questions_section.dart';
import 'package:shatter_vcs/services/app_service.dart';
import 'package:shatter_vcs/theme/style/custom_route.dart';

class EngagePage extends StatefulWidget {
  const EngagePage({super.key});

  @override
  State<EngagePage> createState() => _EngagePageState();
}

class _EngagePageState extends State<EngagePage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int index = 2;
  late final TabController _tabController =
      TabController(length: 4, vsync: this, initialIndex: 2);

  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });

    BlocProvider.of<QuestionBloc>(context).add(GetQuestions(index: index));
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        showSearchResults = false;
      });
      return;
    }

    context.read<SearchBloc>().add(SearchQueryChanged(query));
    setState(() {
      showSearchResults = true;
    });
  }

  Widget _buildHighlightedText(String text, String query) {
    final queryIndex = text.toLowerCase().indexOf(query.toLowerCase());
    if (queryIndex == -1) return Text(text);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: text.substring(0, queryIndex),
              style: TextStyle(color: Colors.grey.shade800, fontSize: 16)),
          TextSpan(
              text: text.substring(queryIndex, queryIndex + query.length),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          TextSpan(
              text: text.substring(queryIndex + query.length),
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 16,
              )),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader(context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            height: 20,
            width: 200,
            color: Colors.grey.shade300,
          ),
          subtitle: Container(
            height: 10,
            width: 100,
            color: Colors.grey.shade300,
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: _buildShimmerLoader(context));
        } else if (state is SearchSuccess) {
          if (state.questions.isEmpty) {
            return const Center(child: Text("No results found"));
          }

          state.questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: state.questions.length,
            itemBuilder: (context, index) {
              final question = state.questions[index];
              // postion the controller to the end

              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade200, width: 1))),
                child: ListTile(
                  tileColor: Colors.white,
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        question.authorName,
                        style: TextStyle(
                            color: Colors.blue.shade500, fontSize: 12),
                      ),
                      Text(AppService.timeAgo(question.createdAt),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                  title: _buildHighlightedText(
                      question.title, _searchController.text),
                  onTap: () {
                    setState(() {
                      _searchController.clear();
                      showSearchResults = false;
                    });
                    // Navigate to question details (implement navigation logic)
                  },
                ),
              );
            },
          );
        } else if (state is SearchFailure) {
          return const Center(child: Text("Error searching questions"));
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          CustomScrollView(
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
                  icon: const Icon(FluentIcons.add_24_regular),
                  onPressed: () {
                    Navigator.of(context)
                        .push(createRoute(const AddQuestionPage()));
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      onTap: (index) {
                        BlocProvider.of<QuestionBloc>(context)
                            .add(GetQuestions(index: index));
                      },
                      controller: _tabController,
                      dragStartBehavior: DragStartBehavior.start,
                      isScrollable: false,
                      tabs: const [
                        Tab(text: "UnAnswered"),
                        Tab(text: "Top Voted"),
                        Tab(text: 'Your Interests'),
                        Tab(text: "Latest"),
                      ],
                      indicatorColor: Colors.blue,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        cursorColor: Colors.grey,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
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
                    ],
                  ),
                ),
              ),
              const QuestionsSection(),
            ],
          ),
          if (showSearchResults)
            Positioned(
              top: kToolbarHeight + 50,
              left: 20,
              right: 20,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _buildSearchResults(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
