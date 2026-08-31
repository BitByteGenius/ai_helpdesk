import 'package:frontend/models/attachment_model.dart';
import 'package:frontend/models/user_model.dart';

/// Ticket model — references the canonical UserModel from user_model.dart.
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
  final String aiConversationTranscript;
  final String aiConfidence;
  final String aiSuggestedRootCause;
  final String aiTroubleshootingAttempted;

  final String? duplicateTicket;

  final List<AttachmentModel> attachments;

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
    required this.aiConversationTranscript,
    required this.aiConfidence,
    required this.aiSuggestedRootCause,
    required this.aiTroubleshootingAttempted,
    required this.duplicateTicket,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

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

    final attachmentsRaw = json["attachments"];
    final List<AttachmentModel> attachmentsList = [];
    if (attachmentsRaw is List) {
      for (final item in attachmentsRaw) {
        if (item is Map<String, dynamic>) {
          attachmentsList.add(AttachmentModel.fromJson(item));
        } else if (item != null) {
          attachmentsList.add(
            AttachmentModel(
              url: item.toString(),
              fileName: "Attachment",
              fileType: "",
              fileSize: 0,
            ),
          );
        }
      }
    }

    final dupRaw = json["duplicateTicket"];
    final String? dupStr = dupRaw is Map
        ? dupRaw["_id"]?.toString()
        : dupRaw?.toString();

    return TicketModel(
      id: _parseString(json["_id"]),
      title: _parseString(json["title"]),
      description: _parseString(json["description"]),
      category: _parseString(json["category"], fallback: "Other"),
      priority: _parseString(json["priority"], fallback: "Medium"),
      status: _parseString(json["status"], fallback: "Open"),
      createdBy: createdBy,
      assignedTo: assignedTo,
      aiSummary: _parseString(json["aiSummary"] ?? json["summary"]),
      suggestedReply: _parseString(json["aiSuggestedReply"] ?? json["suggestedReply"]),
      aiConversationTranscript: _parseString(json["aiConversationTranscript"]),
      aiConfidence: _parseString(json["aiConfidence"], fallback: "Medium"),
      aiSuggestedRootCause: _parseString(json["aiSuggestedRootCause"] ?? json["possibleRootCause"]),
      aiTroubleshootingAttempted: _parseString(json["aiTroubleshootingAttempted"] ?? json["troubleshootingAttempted"]),
      duplicateTicket: dupStr,
      attachments: attachmentsList,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
      "summary": aiSummary,
      "aiSuggestedReply": suggestedReply,
      "aiConversationTranscript": aiConversationTranscript,
      "aiConfidence": aiConfidence,
      "aiSuggestedRootCause": aiSuggestedRootCause,
      "aiTroubleshootingAttempted": aiTroubleshootingAttempted,
      "duplicateTicket": duplicateTicket,
      "attachments": attachments.map((e) => e.toJson()).toList(),
    };
  }
}