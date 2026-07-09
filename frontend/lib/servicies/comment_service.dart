import 'package:dio/dio.dart';

import '../models/comment_model.dart';

class CommentService {
  final Dio _dio;

  CommentService(this._dio);

  /// Get Comments
  Future<List<CommentModel>> getComments(
    String ticketId,
  ) async {
    try {
      final response = await _dio.get(
        "comments/$ticketId",
      );

      return (response.data["data"] as List)
          .map(
            (e) => CommentModel.fromJson(e),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch comments",
      );
    }
  }

  /// Add Comment
  Future<CommentModel> addComment({
    required String ticketId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        "comments/$ticketId",
        data: {
          "message": message,
        },
      );

      return CommentModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to add comment",
      );
    }
  }

  /// Delete Comment
  Future<void> deleteComment(
    String commentId,
  ) async {
    try {
      await _dio.delete(
        "comments/$commentId",
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete comment",
      );
    }
  }

  /// Update Comment
  Future<CommentModel> updateComment(
    String commentId,
    String message,
  ) async {
    try {
      final response = await _dio.put(
        "comments/$commentId",
        data: {
          "message": message,
        },
      );

      return CommentModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to update comment",
      );
    }
  }
}