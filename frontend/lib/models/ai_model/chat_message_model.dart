import 'package:flutter/material.dart';

class ChatMessageModel {
  final String id;
  final String role; // 'user' or 'assistant'
  final String message;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.role,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["_id"]?.toString() ?? UniqueKey().toString(),
      role: json["role"] ?? "user",
      message: json["message"] ?? "",
      createdAt: json["timestamp"] != null
          ? DateTime.tryParse(json["timestamp"]) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": message,
    };
  }
}
