import 'package:dio/dio.dart';
import 'package:frontend/models/ai_model/ai_conversation_model.dart';
import 'package:frontend/servicies/api_service.dart';

class AIChatService {
  final Dio _dio = ApiService.instance.dio;

  /// Send message to persistent chat session
  Future<Map<String, dynamic>> chat({
    required String message,
    String? conversationId,
  }) async {
    try {
      final response = await _dio.post(
        "ai/chat",
        data: {
          "message": message,
          if (conversationId != null) "conversationId": conversationId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to contact AI Copilot",
      );
    }
  }

  /// Generate draft ticket from conversation
  Future<Map<String, dynamic>> createTicketFromChat({
    required String conversationId,
  }) async {
    try {
      final response = await _dio.post(
        "ai/create-ticket",
        data: {
          "conversationId": conversationId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Failed to analyze chat context",
      );
    }
  }

  /// Get list of conversations for history sidebar
  Future<List<AIConversationModel>> getConversations() async {
    try {
      final response = await _dio.get("ai/conversations");
      final List data = response.data["data"] ?? [];
      return data.map((e) => AIConversationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to load conversations",
      );
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(String id) async {
    try {
      await _dio.delete("ai/conversations/$id");
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Failed to delete conversation",
      );
    }
  }

  /// Update conversation details (rename, pin/unpin, or update history)
  Future<AIConversationModel> updateConversation(
    String id, {
    String? title,
    bool? isPinned,
    List<Map<String, dynamic>>? messages,
  }) async {
    try {
      final response = await _dio.put(
        "ai/conversations/$id",
        data: {
          if (title != null) "title": title,
          if (isPinned != null) "isPinned": isPinned,
          if (messages != null) "messages": messages,
        },
      );
      return AIConversationModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Failed to update conversation",
      );
    }
  }


  /// Get a single conversation with all messages
Future<AIConversationModel> getConversation(String id) async {
  try {
    final response = await _dio.get(
      "ai/conversations/$id",
    );

    return AIConversationModel.fromJson(
      response.data["data"],
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data["message"] ??
          "Unable to load conversation",
    );
  }
}
}


