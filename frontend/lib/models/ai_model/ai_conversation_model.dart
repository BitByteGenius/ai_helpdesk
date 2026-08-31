import 'chat_message_model.dart';

class AIConversationModel {
  final String id;
  final String title;
  final bool isPinned;
  final List<ChatMessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  AIConversationModel({
    required this.id,
    required this.title,
    required this.isPinned,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory AIConversationModel.fromJson(Map<String, dynamic> json) {
    final List<ChatMessageModel> msgs = [];
    final messagesRaw = json["messages"];
    if (messagesRaw is List) {
      for (final m in messagesRaw) {
        if (m is Map<String, dynamic>) {
          msgs.add(ChatMessageModel.fromJson(m));
        } else if (m is Map) {
          msgs.add(ChatMessageModel.fromJson(Map<String, dynamic>.from(m)));
        }
      }
    }

    return AIConversationModel(
      id: json["_id"]?.toString() ?? "",
      title: _parseString(json["title"], fallback: "New Chat"),
      isPinned: json["isPinned"] == true,
      messages: msgs,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
