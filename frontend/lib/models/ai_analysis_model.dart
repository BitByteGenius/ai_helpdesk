class AiAnalysisModel {
  final String category;
  final String priority;
  final String aiSummary;
  final bool duplicate;
  final DuplicateTicket? duplicateTicket;

  const AiAnalysisModel({
    required this.category,
    required this.priority,
    required this.aiSummary,
    required this.duplicate,
    this.duplicateTicket,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiAnalysisModel(
      category: _parseString(json["category"], fallback: "Other"),
      priority: _parseString(json["priority"], fallback: "Medium"),
      aiSummary: _parseString(json["aiSummary"] ?? json["summary"]),
      duplicate: json["duplicate"] == true,
      duplicateTicket: json["duplicateTicket"] != null && json["duplicateTicket"] is Map<String, dynamic>
          ? DuplicateTicket.fromJson(json["duplicateTicket"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "priority": priority,
      "aiSummary": aiSummary,
      "duplicate": duplicate,
      "duplicateTicket": duplicateTicket?.toJson(),
    };
  }
}

class DuplicateTicket {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;

  const DuplicateTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory DuplicateTicket.fromJson(Map<String, dynamic> json) {
    return DuplicateTicket(
      id: _parseString(json["_id"] ?? json["id"]),
      title: _parseString(json["title"]),
      description: _parseString(json["description"]),
      status: _parseString(json["status"]),
      priority: _parseString(json["priority"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "status": status,
      "priority": priority,
    };
  }
}