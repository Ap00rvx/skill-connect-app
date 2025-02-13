class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime joinedAt;
  final String? portfolio;
  final String? bio;
   String? profilePicture;
  final List<String> skills;
  final int connectionsCount;
  final int projectsCount;
  final String? github;
  final List<String> projects;
  final List<String> certifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    this.portfolio,
    this.bio,
    this.profilePicture,
    List<String>? skills,
    this.connectionsCount = 0,
    this.projectsCount = 0,
    this.github,
    List<String>? projects,
    List<String>? certifications,
  })  : skills = skills ?? [],
        projects = projects ?? [],
        certifications = certifications ?? [];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt']),
      portfolio: json['portfolio'],
      bio: json['bio'],
      profilePicture: json['profilePicture'],
      skills: List<String>.from(json['skills'] ?? []),
      connectionsCount: json['connectionsCount'] ?? 0,
      projectsCount: json['projectsCount'] ?? 0,
      github: json['github'],
      projects: List<String>.from(json['projects'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
      'portfolio': portfolio,
      'bio': bio,
      'profilePicture': profilePicture,
      'skills': skills,
      'connectionsCount': connectionsCount,
      'projectsCount': projectsCount,
      'github': github,
      'projects': projects,
      'certifications': certifications,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? joinedAt,
    String? portfolio,
    String? bio,
    String? profilePicture,
    List<String>? skills,
    int? connectionsCount,
    int? projectsCount,
    String? github,
    List<String>? projects,
    List<String>? certifications,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      joinedAt: joinedAt ?? this.joinedAt,
      portfolio: portfolio ?? this.portfolio,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      skills: skills ?? this.skills,
      connectionsCount: connectionsCount ?? this.connectionsCount,
      projectsCount: projectsCount ?? this.projectsCount,
      github: github ?? this.github,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
    );
  }
}
