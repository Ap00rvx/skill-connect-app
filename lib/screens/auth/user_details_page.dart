import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/main.dart';
import 'package:shatter_vcs/model/user_model.dart';
import 'package:shatter_vcs/screens/home/home_page.dart';
import 'package:shatter_vcs/services/cloudinary_service.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  File? _profileImage; // Store picked image
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  List<String> _skills = []; // Store skills

  // **Pick Image Function**
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  String imageUrl = "";
  String name =
      FirebaseAuth.instance.currentUser!.displayName ?? "Not Provided ";
  String email = FirebaseAuth.instance.currentUser!.email ?? "Not Provided ";
  // **Add Skill to List**
  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  // **Remove Skill**
  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  // **Save Data (Mock)**
  void _saveUserDetails() async {
    String portfolio = _portfolioController.text.trim();
    String bio = _bioController.text.trim();
    File? image = File(_profileImage!.path);
    
    context.read<UserBloc>().add(SaveUserDetails(
        UserModel(
            name: name,
            email: email,
            joinedAt: DateTime.now(),
            profilePicture: imageUrl,
            portfolio: portfolio,
            bio: bio,
            skills: _skills),
        image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Details"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSaved) {
            showSnackbar("User details saved successfully", false, context);
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            }
          }
          if (state is UserFailure) {
            showSnackbar(state.exception.message, true, context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // **Profile Image Picker**
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage("") as ImageProvider,
                      child: _profileImage == null
                          ? const Icon(FluentIcons.person_32_filled, size: 30)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Name",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                _buildDisabledTextField(name),
                const Text("Email",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                _buildDisabledTextField(email),
                const SizedBox(height: 20),
                // **Portfolio Input**
                const Text("Portfolio Link (Optional)",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                _buildTextField(
                    "Portfolio Link (Optional)", _portfolioController),

                // **Bio Input**
                const Text("Bio (Optional)",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                _buildTextField("Bio (Optional)", _bioController),

                // **Skills Input**
                const SizedBox(height: 10),
                const Text("Skills",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: _skillController,
                          decoration:
                              customInputDecoration(hintText: "Enter Skill")),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: _addSkill,
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // **Skills List**
                Wrap(
                  spacing: 8.0,
                  children: _skills.asMap().entries.map((entry) {
                    int index = entry.key;
                    String skill = entry.value;
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      deleteIconColor: Colors.grey,
                      onDeleted: () => _removeSkill(index),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // **Save Button**
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
                            color: Colors.grey,
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: buttonStyle,
                        onPressed: _saveUserDetails,
                        child: const Text("Save"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
          decoration: customInputDecoration(hintText: hint), enabled: false),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
          controller: controller,
          decoration: customInputDecoration(hintText: hint)),
    );
  }
}
