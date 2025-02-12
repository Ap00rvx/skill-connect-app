import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/circular_avatar_wrapper.dart';
import 'package:shatter_vcs/widgets/profile_shimmer.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';
import 'package:shatter_vcs/widgets/utilities_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserDetails());
  }

  File? _newProfileImage;
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  List<String> _skills = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  void _updateProfile() async {
    final user = (context.read<UserBloc>().state as UserSuccess).user;
    // print(user.toJson());
    final updatedUser = user.copyWith(
      portfolio: _portfolioController.text.isNotEmpty
          ? _portfolioController.text.trim()
          : null,
      bio: _bioController.text.isNotEmpty ? _bioController.text.trim() : null,
      skills: _skills.isNotEmpty ? _skills : null,
    );
    context
        .read<UserBloc>()
        .add(UpdateUserDetails(updatedUser, _newProfileImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const ProfileShimmer();
          }
          if (state is UserUpdated) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackbar("Profile updated Successfully!", false, context);
            });
            context.read<UserBloc>().add(GetUserDetails());
          }
          if (state is UserSuccess) {
            final user = state.user;
            _skills = user.skills ?? []; // Pre-fill skills

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // **Profile Image**
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircularAvatarWrapper(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: _newProfileImage != null
                                ? FileImage(_newProfileImage!)
                                : (user.profilePicture != null
                                        ? NetworkImage(user.profilePicture!)
                                        : const AssetImage(
                                            "assets/default_profile.png"))
                                    as ImageProvider,
                            child: _newProfileImage == null &&
                                    user.profilePicture == null
                                ? const Icon(FluentIcons.person_32_filled,
                                    size: 30)
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text.rich(
                        TextSpan(children: [
                          const TextSpan(
                              text: "Joined - ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  " ${DateFormat.yMMMMd().format(user.joinedAt)}",
                              style: TextStyle(color: Colors.grey[600]))
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // **Name & Email (Disabled)**
                    const Text("Name",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    _buildDisabledTextField(user.name),
                    const Text("Email",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    _buildDisabledTextField(user.email),
                    const SizedBox(height: 20),

                    // **Portfolio Link (Prefilled as Hint)**
                    const Text("Portfolio Link (Optional)",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    _buildTextField("Portfolio Link", _portfolioController,
                        hintText:
                            user.portfolio ?? "Enter your portfolio link"),

                    // **Bio (Prefilled as Hint)**
                    const Text("Bio (Optional)",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    _buildTextField("Bio", _bioController,
                        hintText: user.bio ?? "Tell us about yourself"),
                    const SizedBox(height: 10),

                    // **Skills Section**
                    const Text("Skills",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),

                    // **Existing Skills Display**
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        spacing: 8.0,
                        children: _skills
                            .map((skill) => Chip(
                                  label: Text(skill),
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                  deleteIconColor: Colors.grey,
                                  onDeleted: () =>
                                      _removeSkill(_skills.indexOf(skill)),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // **Add New Skill**
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _skillController,
                              decoration: customInputDecoration(
                                  hintText: "Enter Skill")),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: _addSkill,
                          child: const Text("Add",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // **Update Profile Button**
                    Center(
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 16.0),
                                textStyle: const TextStyle(fontSize: 16),
                                fixedSize: const Size(double.infinity, 50),
                                minimumSize: const Size(400, 60),
                              ),
                              onPressed: () {},
                              child: const CircularProgressIndicator(
                                  color: Colors.grey),
                            );
                          }
                          return ElevatedButton(
                            style: buttonStyle,
                            onPressed: _updateProfile,
                            child: const Text("Update Profile"),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    UtilitiesList()
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: Text("Error fetching data"),
          );
        },
      ),
    );
  }

  // **Disabled Text Field (For Name & Email)**
  Widget _buildDisabledTextField(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: customInputDecoration(hintText: text),
        enabled: false,
      ),
    );
  }

  // **General Text Field with Prefilled Hint**
  Widget _buildTextField(String label, TextEditingController controller,
      {String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: customInputDecoration(hintText: hintText ?? label),
      ),
    );
  }
}
