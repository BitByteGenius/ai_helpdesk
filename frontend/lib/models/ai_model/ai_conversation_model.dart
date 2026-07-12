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

  factory AIConversationModel.fromJson(Map<String, dynamic> json) {
    return AIConversationModel(
      id: json["_id"]?.toString() ?? "",
      title: json["title"] ?? "New Chat",
      isPinned: json["isPinned"] ?? false,
      messages: json["messages"] == null
          ? []
          : (json["messages"] as List)
              .map((e) => ChatMessageModel.fromJson(e))
              .toList(),
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"]) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
