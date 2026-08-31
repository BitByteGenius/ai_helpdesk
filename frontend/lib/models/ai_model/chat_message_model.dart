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

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join("\n");
    return val.toString();
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["_id"]?.toString() ?? UniqueKey().toString(),
      role: _parseString(json["role"], fallback: "user"),
      message: _parseString(json["message"] ?? json["content"]),
      createdAt: json["timestamp"] != null || json["createdAt"] != null
          ? DateTime.tryParse((json["timestamp"] ?? json["createdAt"]).toString()) ?? DateTime.now()
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
