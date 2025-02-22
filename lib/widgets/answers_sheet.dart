import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/answer/answer_bloc.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/app_service.dart';
import 'package:shatter_vcs/services/user_service.dart';
import 'package:shatter_vcs/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

void showAnswersBottomSheet(BuildContext context, QuestionModel question) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) => BlocProvider(
      create: (context) => AnswerBloc()..add(GetAnswers(question.id)),
      child: FractionallySizedBox(
        heightFactor: 0.8, // 80% of screen height
        child: AnswerBottomSheet(question: question),
      ),
    ),
  );
}

class AnswerBottomSheet extends StatefulWidget {
  final QuestionModel question;

  const AnswerBottomSheet({Key? key, required this.question}) : super(key: key);

  @override
  _AnswerBottomSheetState createState() => _AnswerBottomSheetState();
}

class _AnswerBottomSheetState extends State<AnswerBottomSheet> {
  final TextEditingController _answerController = TextEditingController();
  Widget buildShimmerListTile() {
    return ListView.builder(
      itemCount: 6, // Display 6 shimmer items
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          child: ListTile(
            isThreeLine: true,
            tileColor: Colors.grey.shade50,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitAnswer() {
    final answerText = _answerController.text.trim();
    if (answerText.isEmpty) return;

    context.read<AnswerBloc>().add(AddAnswer(widget.question.id, answerText));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "Answers",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<AnswerBloc, AnswerState>(
                listener: (context, state) {
                  if (state is AnswerSuccess) {
                    _answerController.clear();
                  } else if (state is AnswerFailure) {
                    showSnackbar(state.exception.message, true, context);
                  }
                },
                builder: (context, state) {
                  if (state is AnswerLoading) {
                    return buildShimmerListTile();
                  } else if (state is AnswerFailure) {
                    return Center(
                      child: Text(
                        "Error: ${state.exception.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is AnswerSuccess && state.answers.isEmpty) {
                    return const Center(
                      child: Text(
                        "No answers yet. Be the first to answer!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else if (state is AnswerSuccess) {
                    return ListView.builder(
                      itemCount: state.answers.length,
                      itemBuilder: (context, index) {
                        final answer = state.answers[index];
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            isThreeLine: true,
                            tileColor: Colors.grey.shade50,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  answer.authorName ==
                                          locator.get<UserService>().user!.name
                                      ? "You"
                                      : answer.authorName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  AppService.timeAgo(answer.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Text(
                                  answer.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(
                                              Icons.keyboard_arrow_up_rounded,
                                              size: 24,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {}),
                                        const SizedBox(width: 5),
                                        Text('${answer.upvotes.length}'),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 24,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {},
                                        ),
                                        const SizedBox(width: 5),
                                        Text('${answer.downvotes.length}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Unexpected state"));
                },
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: "Write your answer...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<AnswerBloc, AnswerState>(
                  builder: (context, state) {
                    if (state is AnswerLoading) {
                      return const CircularProgressIndicator();
                    }
                    return IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _submitAnswer,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
