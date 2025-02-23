import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shatter_vcs/bloc/user/user_bloc.dart';
import 'package:shatter_vcs/model/user_model.dart';
import 'package:shatter_vcs/screens/home/home_page.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  int _currentStep = 0;
  File? _profileImage;
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _gitController = TextEditingController();

  List<String> _skills = [];
  String imageUrl = "";
  String name =
      FirebaseAuth.instance.currentUser!.displayName ?? "Not Provided ";
  String email = FirebaseAuth.instance.currentUser!.email ?? "Not Provided ";

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
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

  void _saveUserDetails() {
    String portfolio = _portfolioController.text.trim();
    String bio = _bioController.text.trim();
    File? image = _profileImage;

    context.read<UserBloc>().add(SaveUserDetails(
        UserModel(
          name: name,
          email: email,
          joinedAt: DateTime.now(),
          profilePicture: imageUrl,
          portfolio: portfolio,
          bio: bio,
          skills: _skills,
          id: FirebaseAuth.instance.currentUser!.uid,
        ),
        image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: const [
        Center(
          child: Text(
            "By continuing, you agree to the Terms and Conditions",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
        if (state is UserLoading) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        }
        if (state is UserSaved) {
          Navigator.pop(context);
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
          Navigator.pop(context);
          showSnackbar(state.exception.message, true, context);
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stepper(
                type: StepperType.vertical,
                connectorColor: const WidgetStatePropertyAll(Colors.blue),
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 3) {
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    _saveUserDetails();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                steps: [
                  // Step 1: Profile Picture
                  Step(
                    title: const Text("Profile Picture"),
                    content: Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage("") as ImageProvider,
                          child: _profileImage == null
                              ? const Icon(FluentIcons.save_image_20_filled,
                                  size: 30)
                              : null,
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                  ),

                  // Step 2: Basic Information
                  Step(
                    title: const Text("Basic Information"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Name",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        _buildDisabledTextField(name),
                        const Text("Email",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        _buildDisabledTextField(email),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                  ),

                  // Step 3: Portfolio & Bio
                  Step(
                    title: const Text("Portfolio & Bio"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Portfolio Link (Optional)",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        _buildTextField("Portfolio Link", _portfolioController),
                        const Text("Bio (Optional)",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        _buildTextField("Bio", _bioController),
                        const Text("GitHub",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        _buildTextField("GitHub Link", _gitController),
                      ],
                    ),
                    isActive: _currentStep >= 2,
                  ),

                  // Step 4: Skills
                  Step(
                    title: const Text("Skills"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _skillController,
                                decoration: customInputDecoration(
                                    hintText: "Enter Skill"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: _addSkill,
                              child: const Text("Add",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
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
                      ],
                    ),
                    isActive: _currentStep >= 3,
                  ),
                ],
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text("Back",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: details.onStepContinue,
                        child: Text(_currentStep == 3 ? "Finish" : "Next"),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
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
