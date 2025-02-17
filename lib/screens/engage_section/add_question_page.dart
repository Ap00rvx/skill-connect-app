import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shatter_vcs/bloc/question/question_bloc.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/main.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/user_service.dart';
import 'package:shatter_vcs/theme/style/button_style.dart';
import 'package:shatter_vcs/theme/style/text_field_decoration.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final List<String> _tags = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _postQuestion() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      showSnackbar("Title cannot be empty", false, context);
      return;
    }
    if (description.length < 20) {
      showSnackbar(
          "Description should be atleast 20 characters", false, context);
      return;
    }

    if (_tags.length < 3) {
      showSnackbar("Provide atleast 3 Tags", false, context);
      return;
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = locator.get<UserService>().user!;

    final questionModel = QuestionModel(
        id: id,
        title: title,
        description: description,
        authorId: user.id,
        authorName: user.name,
        createdAt: DateTime.now(),
        tags: _tags);

    context
        .read<QuestionBloc>()
        .add(CreateQuestion(questionModel, _selectedImage));
  }

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    setState(() {
      _tags.clear();
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Ask a public Question'),
        actions: [
          TextButton(
            onPressed: _postQuestion, // Disabled if less than 3 tags
            child: const Text('Post', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: BlocListener<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionSaved) {
            Navigator.pop(context);
            showSnackbar("Question posted Successfully", false, context);
            if (mounted) {
              _clearControllers();
            }
          }
          if (state is QuestionFailure) {
            Navigator.pop(context);
            showSnackbar(state.exception.message, false, context);
          }
          if (state is QuestionLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.white.withOpacity(0.5),
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  );
                });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Writing a good question',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'You’re ready to ask a programming-related question and this form will help guide you through the process.',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Here are a few tips to help you write a high-quality question:',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '1. Summarize the problem',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                    const Text(
                      '2. Provide details and any research',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                    const Text(
                      '3. Add tags to describe the topic',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                    const Text(
                      '4. Add an image (optional)',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Title",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
              ),
              const SizedBox(height: 2),
              const Text(
                  "Be specific and imagine you’re asking a question to another person.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black54)),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: customInputDecoration(
                    hintText: "eg. How to use Flutter ? "),
              ),
              const SizedBox(height: 20),
              const Text(
                "What are the details of your problem?",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
              ),
              const SizedBox(height: 2),
              const Text(
                  "Introduce the problem and expand on what you put in the title.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black54)),
              const SizedBox(height: 10),
              TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: customInputDecoration(
                      hintText: "Describe your problem ")),
              const SizedBox(height: 10),
              const Text(
                "Tags",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
              ),
              const SizedBox(height: 2),
              const Text(
                  "Add up to 5 tags to describe what your question is about.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black54)),
              const SizedBox(height: 10),
              TextField(
                controller: _tagsController,
                decoration: customInputDecoration(
                  hintText: "Add tags (at least 3)",
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    backgroundColor: Colors.blue.shade50,
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              _selectedImage == null
                  ? ElevatedButton.icon(
                      style: buttonStyle,
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Upload Image (Optional)"),
                    )
                  : Stack(
                      children: [
                        Image.file(
                          _selectedImage!,
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
