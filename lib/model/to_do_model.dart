class Todo {
  String title;
  String description;
  DateTime date;
  bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });

  // Convert a Todo object to a Map (useful for storage like databases)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      // Store date as ISO string
    };
  }

  // Create a Todo object from a Map
  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'],
      // Convert string back to DateTime
    );
  }
  // copy with method
  Todo copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
