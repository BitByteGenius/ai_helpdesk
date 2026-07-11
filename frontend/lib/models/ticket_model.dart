import 'package:frontend/models/user_model.dart';

/// Ticket model — references the canonical UserModel from user_model.dart.
///
/// NOTE: The inner UserModel class that previously lived here has been
/// removed to eliminate the duplicate-class conflict with user_model.dart.
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
    // createdBy may arrive as a populated object or a bare string ID
    final createdByRaw = json["createdBy"];
    final UserModel createdBy;
    if (createdByRaw is Map<String, dynamic>) {
      createdBy = UserModel.fromJson(createdByRaw);
    } else {
      createdBy = UserModel(
        id: createdByRaw?.toString() ?? "",
        name: "",
        email: "",
        phone: "",
        role: "user",
        profileImage: "",
      );
    }

    // assignedTo may be null, a string ID, or a populated object
    final assignedToRaw = json["assignedTo"];
    final UserModel? assignedTo;
    if (assignedToRaw == null) {
      assignedTo = null;
    } else if (assignedToRaw is Map<String, dynamic>) {
      assignedTo = UserModel.fromJson(assignedToRaw);
    } else {
      assignedTo = UserModel(
        id: assignedToRaw.toString(),
        name: "",
        email: "",
        phone: "",
        role: "user",
        profileImage: "",
      );
    }

    return TicketModel(
      id: json["_id"]?.toString() ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "Other",
      priority: json["priority"] ?? "Medium",
      status: json["status"] ?? "Open",
      createdBy: createdBy,
      assignedTo: assignedTo,
      aiSummary: json["summary"] ?? "",
      suggestedReply: json["suggestedReply"] ?? "",
      duplicateTicket: json["duplicateTicket"] ?? false,
      attachments: json["attachments"] == null
          ? []
          : List<String>.from(json["attachments"]),
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"]) ?? DateTime.now()
          : DateTime.now(),
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