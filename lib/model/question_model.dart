class QuestionModel {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  String image;
  final List<String> tags;
  final List<String> upvotes; // Changed from int to List<String>
  final List<String> downvotes; // Changed from int to List<String>
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.image = '',
    List<String>? tags,
    List<String>? upvotes,
    List<String>? downvotes,
    List<AnswerModel>? answers,
  })  : tags = tags ?? [],
        upvotes = upvotes ?? [],
        downvotes = downvotes ?? [],
        answers = answers ?? [];

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      image: json['image'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags'] ?? []),
      upvotes: List<String>.from(json['upvotes'] ?? []), // Changed to List<String>
      downvotes: List<String>.from(json['downvotes'] ?? []), // Changed to List<String>
      answers: (json['answers'] as List<dynamic>?)?.map((a) => AnswerModel.fromJson(a)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      "image": image,
      'authorName': authorName,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'upvotes': upvotes, // Now stores list of user IDs
      'downvotes': downvotes, // Now stores list of user IDs
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class AnswerModel {
  final String id;
  final String questionId;
  final String authorId;
  final String authorName;
  final String description;
  final DateTime createdAt;
  final List<String> upvotes; // Changed from int to List<String>
  final List<String> downvotes; // Changed from int to List<String>

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.authorName,
    required this.description,
    required this.createdAt,
    List<String>? upvotes,
    List<String>? downvotes,
  })  : upvotes = upvotes ?? [],
        downvotes = downvotes ?? [];

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? '',
      questionId: json['questionId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      upvotes: List<String>.from(json['upvotes'] ?? []), // Changed to List<String>
      downvotes: List<String>.from(json['downvotes'] ?? []), // Changed to List<String>
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'authorId': authorId,
      'authorName': authorName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'upvotes': upvotes, // Now stores list of user IDs
      'downvotes': downvotes, // Now stores list of user IDs
    };
  }
}
