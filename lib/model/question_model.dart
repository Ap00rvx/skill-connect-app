class QuestionModel {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
   String image; 
  final List<String> tags;
  final int upvotes;
  final int downvotes;
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
    this.upvotes = 0,
    this.downvotes = 0,
    List<AnswerModel>? answers,
  })  : tags = tags ?? [],
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
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
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
      'upvotes': upvotes,
      'downvotes': downvotes,
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
  final int upvotes;
  final int downvotes;

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.authorName,
    required this.description,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? '',
      questionId: json['questionId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
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
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}
