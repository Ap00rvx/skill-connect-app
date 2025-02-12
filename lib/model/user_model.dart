class UserModel {
  String name;
  String email;
  DateTime joinedAt;
  String? portfolio;
  String? bio;
  String? profilePicture;
  List<String>? skills;
  UserModel({
    required this.name,
    required this.email,
    required this.joinedAt,
    this.portfolio,
    this.bio,
    this.profilePicture,
    this.skills,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      joinedAt: DateTime.parse(json['joinedAt']),
      portfolio: json['portfolio'],
      bio: json['bio'],
      profilePicture: json['profilePicture'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
      'portfolio': portfolio,
      'bio': bio,
      'profilePicture': profilePicture,
      'skills': skills,
    };
  }

  // copy with method
  UserModel copyWith({
    String? name,
    String? email,
    DateTime? joinedAt,
    String? portfolio,
    String? bio,
    String? profilePicture,
    List<String>? skills,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      joinedAt: joinedAt ?? this.joinedAt,
      portfolio: portfolio ?? this.portfolio,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      skills: skills ?? this.skills,
    );
  }
}
