class CommentModel {
  final String id;
  final String ticketId;
  final String message;
  final DateTime createdAt;
  final CommentUser user;
  final bool isEdited;

  CommentModel({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.createdAt,
    required this.user,
    required this.isEdited,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final ticketRaw = json["ticket"];
    final ticketId = ticketRaw is Map
        ? (ticketRaw["_id"] ?? ticketRaw["id"] ?? "")
        : ticketRaw ?? "";

    final userRaw = json["user"] ?? json["author"];

    return CommentModel(
      id: _parseString(json["_id"]),
      ticketId: _parseString(ticketId),
      message: _parseString(json["message"]),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? "") ?? DateTime.now(),
      user: CommentUser.fromJson(userRaw is Map<String, dynamic> ? userRaw : {}),
      isEdited: json["isEdited"] == true,
    );
  }
}

class CommentUser {
  final String id;
  final String name;
  final String image;

  CommentUser({
    required this.id,
    required this.name,
    required this.image,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: _parseString(json["_id"]),
      name: _parseString(json["name"]),
      image: _parseString(json["profileImage"]),
    );
  }
}
