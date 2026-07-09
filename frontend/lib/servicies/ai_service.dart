import 'package:dio/dio.dart';
import 'package:frontend/core/constant/api_constant.dart';
import 'package:get_storage/get_storage.dart';

import '../models/ai_analysis_model.dart';

class AiService {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  AiService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.timeout;
    _dio.options.receiveTimeout = ApiConstants.timeout;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read("token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }

  /// Analyze Ticket
  Future<AiAnalysisModel> analyzeTicket({
    required String title,
    required String description,
  }) async {
    final response = await _dio.post(
      "/ai/analyze-ticket",
      data: {
        "title": title,
        "description": description,
      },
    );

    return AiAnalysisModel.fromJson(
      response.data["data"],
    );
  }

  /// Generate Reply
  Future<String> generateReply({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    final response = await _dio.post(
      "/ai/reply",
      data: {
        "title": title,
        "description": description,
        "category": category,
        "priority": priority,
      },
    );

    return response.data["data"]["reply"];
  }

  /// Regenerate Summary
  Future<String> summarize(
    String description,
  ) async {
    final response = await _dio.post(
      "/ai/summary",
      data: {
        "description": description,
      },
    );

    return response.data["data"]["summary"];
  }

  /// Predict Category
  Future<String> category(
    String description,
  ) async {
    final response = await _dio.post(
      "/ai/category",
      data: {
        "description": description,
      },
    );

    return response.data["data"]["category"];
  }

  /// Predict Priority
  Future<String> priority(
    String description,
  ) async {
    final response = await _dio.post(
      "/ai/priority",
      data: {
        "description": description,
      },
    );

    return response.data["data"]["priority"];
  }
}