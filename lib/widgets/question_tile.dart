import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shatter_vcs/bloc/question/question_bloc.dart';
import 'package:shatter_vcs/locator.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/app_service.dart';
import 'package:shatter_vcs/services/user_service.dart';

class QuestionTile extends StatefulWidget {
  final QuestionModel question;

  const QuestionTile({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  bool isExpanded = false;
  late bool isUpvoted;
  late bool isDownvoted;
  final String userId = locator.get<UserService>().user!.id;

  @override
  void initState() {
    super.initState();
    isUpvoted = widget.question.upvotes.contains(userId);
    isDownvoted = widget.question.downvotes.contains(userId);
  }

  void _handleUpvote() {
    setState(() {
      if (isUpvoted) {
        widget.question.upvotes.remove(userId);
      } else {
        widget.question.upvotes.add(userId);
        widget.question.downvotes.remove(userId);
        isDownvoted = false;
      }
      isUpvoted = !isUpvoted;

      BlocProvider.of<QuestionBloc>(context).add(UpdateQuestionVote(
        widget.question,
        true,
      ));
    });
  }

  void _handleDownvote() {
    setState(() {
      if (isDownvoted) {
        widget.question.downvotes.remove(userId);
      } else {
        widget.question.downvotes.add(userId);
        widget.question.upvotes.remove(userId);
        isUpvoted = false;
      }
      isDownvoted = !isDownvoted;
      BlocProvider.of<QuestionBloc>(context).add(UpdateQuestionVote(
        widget.question,
        false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    String trimmedText = widget.question.description;
    String moreText = '';

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.question.description,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    if (textPainter.didExceedMaxLines) {
      int cutoff = textPainter.getOffsetBefore(textPainter
              .getPositionForOffset(
                  Offset(textPainter.width, textPainter.height))
              .offset) ??
          widget.question.description.length;
      trimmedText = widget.question.description.substring(0, cutoff).trim();
      moreText = "read more";
    }

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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    AppService.timeAgo(widget.question.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.question.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        isExpanded ? widget.question.description : trimmedText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (!isExpanded && moreText.isNotEmpty) ...[
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: moreText,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: widget.question.tags.map((tag) {
              return Chip(
                label: Text(tag),
                backgroundColor: Colors.blue.shade100,
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 24,
                      color: isUpvoted ? Colors.green : Colors.grey,
                    ),
                    onPressed: _handleUpvote,
                  ),
                  const SizedBox(width: 5),
                  Text('${widget.question.upvotes.length}'),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: isDownvoted ? Colors.red : Colors.grey,
                    ),
                    onPressed: _handleDownvote,
                  ),
                  const SizedBox(width: 5),
                  Text('${widget.question.downvotes.length}'),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 18),
                  const SizedBox(width: 5),
                  Text('${widget.question.answers.length} answers'),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
