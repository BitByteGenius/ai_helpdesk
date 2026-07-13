import 'package:dio/dio.dart';
import 'package:frontend/servicies/api_service.dart';
import '../models/ai_analysis_model.dart';

/// AI service — uses the singleton ApiService Dio so auth token
/// from SharedPreferences is automatically injected on every request.
class AiService {
  final Dio _dio = ApiService.instance.dio;

  /// Analyze Ticket — returns category, priority, summary, duplicate flag
  Future<AiAnalysisModel> analyzeTicket({
    required String title,
    required String description,
  }) async {
    final response = await _dio.post(
      "ai/analyze-ticket",
      data: {
        "title": title,
        "description": description,
      },
    );

    return AiAnalysisModel.fromJson(response.data["data"]);
  }

  /// Generate a suggested reply for a ticket
  Future<String> generateReply({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    final response = await _dio.post(
      "ai/reply",
      data: {
        "title": title,
        "description": description,
        "category": category,
        "priority": priority,
      },
    );

    return response.data["data"]["reply"] as String? ?? "";
  }

  /// Summarize a ticket description
  Future<String> summarize(String description) async {
    final response = await _dio.post(
      "ai/summary",
      data: {"description": description},
    );

    return response.data["data"]["summary"] as String? ?? "";
  }

  /// Predict category from description
  Future<String> category(String description) async {
    final response = await _dio.post(
      "ai/category",
      data: {"description": description},
    );

    return response.data["data"]["category"] as String? ?? "";
  }

  /// Predict priority from description
  Future<String> priority(String description) async {
    final response = await _dio.post(
      "ai/priority",
      data: {"description": description},
    );

    return response.data["data"]["priority"] as String? ?? "";
  }
}