import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shatter_vcs/screens/auth/auth_page.dart';
import 'package:shatter_vcs/services/auth_service.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class UtilitiesList extends StatefulWidget {
  @override
  State<UtilitiesList> createState() => _UtilitiesListState();
}

class _UtilitiesListState extends State<UtilitiesList> {
  final List<Map<String, dynamic>> utilities = [
    {"title": "Downloads", "icon": FluentIcons.arrow_download_24_filled},
    {"title": "Usage Analytics", "icon": FluentIcons.chart_multiple_24_filled},
    {"title": "Ask Help-Desk", "icon": FluentIcons.chat_help_24_filled},
    {"title": "Log-Out", "icon": FluentIcons.sign_out_24_filled},
  ];

  void showLogoutConfirmSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      "Log-Out",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text("Are you sure you want to log-out?"),
                  ),
                  ListTile(
                    title: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      showSnackbar("User Signed out", false, context);
                      if (mounted) {
                        await AuthService().signOut().then(
                              (value) => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthPage(),
                                ),
                                (route) => false,
                              ),
                            );
                      }
                    },
                  ),
                  ListTile(
                    title: const Text("Cancel"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: utilities.map((item) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade400, width: 1.0)),
            child: ListTile(
              leading: Icon(item["icon"], color: Colors.blue),
              title: Text(item["title"],
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                if (item["title"] == "Log-Out") {
                  showLogoutConfirmSheet();
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
