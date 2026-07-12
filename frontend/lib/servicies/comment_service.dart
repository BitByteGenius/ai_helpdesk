import 'package:dio/dio.dart';
import 'package:frontend/servicies/api_service.dart';
import '../models/comment_model.dart';

/// Comment service — uses the singleton ApiService Dio so auth token
/// from SharedPreferences is automatically injected on every request.
class CommentService {
  final Dio _dio = ApiService.instance.dio;

  /// Get all comments for a ticket
  Future<List<CommentModel>> getComments(String ticketId) async {
    try {
      final response = await _dio.get("tickets/$ticketId/comments");

      return (response.data["data"] as List)
          .map((e) => CommentModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to fetch comments",
      );
    }
  }

  /// Add a comment to a ticket
  Future<CommentModel> addComment({
    required String ticketId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        "tickets/$ticketId/comments",
        data: {"message": message},
      );

      return CommentModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to add comment",
      );
    }
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _dio.delete("comments/$commentId");
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to delete comment",
      );
    }
  }

  /// Update a comment
  Future<CommentModel> updateComment(
    String commentId,
    String message,
  ) async {
    try {
      final response = await _dio.put(
        "comments/$commentId",
        data: {"message": message},
      );

      return CommentModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to update comment",
      );
    }
  }
}
