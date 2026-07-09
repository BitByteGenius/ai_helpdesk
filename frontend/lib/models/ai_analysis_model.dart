class AiAnalysisModel {
  final String category;
  final String priority;
  final String summary;
  final bool duplicate;
  final DuplicateTicket? duplicateTicket;

  const AiAnalysisModel({
    required this.category,
    required this.priority,
    required this.summary,
    required this.duplicate,
    this.duplicateTicket,
  });

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiAnalysisModel(
      category: json["category"] ?? "Other",
      priority: json["priority"] ?? "Medium",
      summary: json["summary"] ?? "",
      duplicate: json["duplicate"] ?? false,
      duplicateTicket: json["duplicateTicket"] != null
          ? DuplicateTicket.fromJson(json["duplicateTicket"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "priority": priority,
      "summary": summary,
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

  factory DuplicateTicket.fromJson(Map<String, dynamic> json) {
    return DuplicateTicket(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      status: json["status"] ?? "",
      priority: json["priority"] ?? "",
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