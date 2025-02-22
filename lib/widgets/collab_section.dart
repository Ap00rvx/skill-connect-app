import 'package:flutter/material.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/services/user_service.dart';

class CollabSection extends StatefulWidget {
  const CollabSection({super.key});

  @override
  State<CollabSection> createState() => _CollabSectionState();
}

class _CollabSectionState extends State<CollabSection> {
  final user = locator.get<UserService>().user;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          color: Colors.white,
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(color: Colors.grey.shade300, width: 2)),
              child: CircleAvatar(
                radius: 23,
                backgroundImage: NetworkImage(user!.profilePicture.toString()),
              ),
            ),
            title: const Text(
              "Flutter-based E-commerce App",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            subtitle: const Text(
              "Collaborated with 5 others",
              style: const TextStyle(color: Colors.black38),
            ),
            trailing: const Icon(
              Icons.more_vert,
              color: Colors.black38,
            ),
          ),
        );
      },
    );
  }
}
