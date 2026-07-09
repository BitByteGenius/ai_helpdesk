import 'package:dio/dio.dart';
import 'package:frontend/models/ai_model/ai_chat_model.dart';



class AIChatService {
  final Dio _dio;

  AIChatService(this._dio);

  Future<AIChatModel> chat({
    required String message,
    List<Map<String, dynamic>> history = const [],
  }) async {
    try {
      final response = await _dio.post(
        "ai/chat",
        data: {
          "message": message,
          "history": history,
        },
      );

      return AIChatModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to contact AI Copilot",
      );
    }
  }
}