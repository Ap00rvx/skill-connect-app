import 'package:flutter/material.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/services/user_service.dart';

class QuestionsSection extends StatefulWidget {
  const QuestionsSection({super.key});

  @override
  State<QuestionsSection> createState() => _QuestionsSectionState();
}

class _QuestionsSectionState extends State<QuestionsSection> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          locator.get<UserService>().user!.profilePicture!),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '2 hours ago',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'What is the best way to learn Flutter?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined),
                    const SizedBox(width: 5),
                    const Text('10'),
                    const SizedBox(width: 10),
                    const Icon(Icons.thumb_down_alt_outlined),
                    const SizedBox(width: 5),
                    const Text('2'),
                  ],
                ),
              ],
            ),
          );
        },
        childCount: 10, // Number of items
      ),
    );
  }
}
