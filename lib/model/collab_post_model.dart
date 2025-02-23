class CollaborationPost {
  final String id; // Unique Post ID
  final String title; // Project or Collaboration Title
  final String description; // Detailed description of the collaboration
  final String authorId; // ID of the user who posted it
  final String authorName; // Name of the author
  final List<String> requiredSkills; // List of required skills for the project
  final String projectType; // Type of project (Freelance, Open Source, Startup, etc.)
  final DateTime postedAt; // Date when the post was created
  final DateTime? deadline; // Optional deadline for the project
  final bool isOpen; // Whether the collaboration is still open
  final double? budget; // Optional budget for the project
  final String? collaborationMode; // Remote, Hybrid, On-Site
  final List<String> applicants; // List of user IDs who applied
  final String? status; // Status: "Open", "In Progress", "Completed", "Closed"
  final String? contactEmail; // Contact email for collaboration
  final String? projectLink; // External link to GitHub, Figma, etc.

  CollaborationPost({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.requiredSkills,
    required this.projectType,
    required this.postedAt,
    this.deadline,
    this.isOpen = true,
    this.budget,
    this.collaborationMode,
    this.applicants = const [],
    this.status = "Open",
    this.contactEmail,
    this.projectLink,
  });

  /// Convert a CollaborationPost to a JSON object (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      
      'requiredSkills': requiredSkills,
      'projectType': projectType,
      'postedAt': postedAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isOpen': isOpen,
      'budget': budget,
      'collaborationMode': collaborationMode,
      'applicants': applicants,
      'status': status,
      'contactEmail': contactEmail,
      'projectLink': projectLink,
    };
  }

  /// Create a CollaborationPost from a JSON object (for fetching from Firestore)
  factory CollaborationPost.fromJson(Map<String, dynamic> json) {
    return CollaborationPost(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      requiredSkills: List<String>.from(json['requiredSkills']),
      projectType: json['projectType'],
      postedAt: DateTime.parse(json['postedAt']),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isOpen: json['isOpen'],
      budget: json['budget']?.toDouble() ?? 0.0,
      collaborationMode: json['collaborationMode'],
      applicants: List<String>.from(json['applicants']),
      status: json['status'],
      contactEmail: json['contactEmail'],
      projectLink: json['projectLink'],
    );
  }

  /// Create a new instance with modified fields
  CollaborationPost copyWith({
    String? id,
    String? title,
    String? description,
    String? authorId,
    String? authorName,
    String? authorProfileImage,
    List<String>? requiredSkills,
    String? projectType,
    DateTime? postedAt,
    DateTime? deadline,
    bool? isOpen,
    double? budget,
    String? collaborationMode,
    List<String>? applicants,
    String? status,
    String? contactEmail,
    String? projectLink,
  }) {
    return CollaborationPost(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      projectType: projectType ?? this.projectType,
      postedAt: postedAt ?? this.postedAt,
      deadline: deadline ?? this.deadline,
      isOpen: isOpen ?? this.isOpen,
      budget: budget ?? this.budget,
      collaborationMode: collaborationMode ?? this.collaborationMode,
      applicants: applicants ?? this.applicants,
      status: status ?? this.status,
      contactEmail: contactEmail ?? this.contactEmail,
      projectLink: projectLink ?? this.projectLink,
    );
  }
  // create a status enum



}
  enum Status{
    OPEN,
    INPROGRESS,
    COMPLETED,
    CLOSED,
  }
   
