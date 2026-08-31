class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? referenceId;
  final String? referenceModel;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.referenceId,
    this.referenceModel,
    required this.createdAt,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseString(json["_id"]),
      title: _parseString(json["title"]),
      message: _parseString(json["message"]),
      type: _parseString(json["type"], fallback: "system"),
      isRead: json["isRead"] == true,
      referenceId: json["referenceId"]?.toString(),
      referenceModel: json["referenceModel"]?.toString(),
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
