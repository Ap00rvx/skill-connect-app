import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/user_model.dart';
import 'package:shatter_vcs/services/user_service.dart';
import 'package:shatter_vcs/widgets/collab_section.dart';
import 'package:shatter_vcs/widgets/hero.dart';
import 'package:shatter_vcs/widgets/skill_carousel.dart';
import 'package:shatter_vcs/widgets/skill_share_shimmer.dart';

class SkillSharePage extends StatefulWidget {
  const SkillSharePage({super.key});

  @override
  State<SkillSharePage> createState() => _SkillSharePageState();
}

class _SkillSharePageState extends State<SkillSharePage> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    final userService = locator.get<UserService>();
    if (userService.user != null) {
      user = userService.user!;
    } else {
      context.read<UserBloc>().add(GetUserDetails());
    }
  }

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserSuccess) {
        user = state.user;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicture.toString()),
                child:
                    user.profilePicture == "" ? const Icon(Icons.person) : null,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  user.email.toString(),
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    cursorColor: Colors.grey,
                    onChanged: (query) {},
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
                  const SizedBox(height: 20),
                  const HeroContainer(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Find your Skill",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  const SkillCarousel(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Collaborate with others",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See All",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  const CollabSection()
                ],
              ),
            ),
          ),
        );
      } else if (state is UserFailure) {
        return const Center(child: Text("Failed to load user data"));
      } else {
        return const SkillShareShimmer();
      }
    });
  }
}
