class TicketModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;

  final UserModel createdBy;
  final UserModel? assignedTo;

  final String aiSummary;
  final String suggestedReply;

  final bool duplicateTicket;

  final List<String> attachments;

  final DateTime createdAt;
  final DateTime updatedAt;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdBy,
    this.assignedTo,
    required this.aiSummary,
    required this.suggestedReply,
    required this.duplicateTicket,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json["_id"] ?? "",

      title: json["title"] ?? "",

      description: json["description"] ?? "",

      category: json["category"] ?? "Other",

      priority: json["priority"] ?? "Medium",

      status: json["status"] ?? "Open",

      createdBy: UserModel.fromJson(
        json["createdBy"] ?? {},
      ),

      assignedTo: json["assignedTo"] != null
          ? UserModel.fromJson(json["assignedTo"])
          : null,

      aiSummary: json["summary"] ?? "",

      suggestedReply: json["suggestedReply"] ?? "",

      duplicateTicket:
          json["duplicateTicket"] ?? false,

      attachments:
          json["attachments"] == null
              ? []
              : List<String>.from(
                  json["attachments"],
                ),

      createdAt: DateTime.parse(
        json["createdAt"],
      ),

      updatedAt: DateTime.parse(
        json["updatedAt"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",

      name: json["name"] ?? "",

      email: json["email"] ?? "",

      profileImage:
          json["profileImage"] ?? "",
    );
  }
}