import 'package:dio/dio.dart';
import 'package:frontend/servicies/api_service.dart';
import '../models/notification_model.dart';

/// Notification service — uses the singleton ApiService Dio so auth token
/// from SharedPreferences is automatically injected on every request.
class NotificationService {
  final Dio _dio = ApiService.instance.dio;

  /// Get all notifications for the current user
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get("notifications");
    final raw = response.data;
    final list = raw is List
        ? raw
        : raw is Map
            ? (raw["data"] is List ? raw["data"] as List : <dynamic>[])
            : <dynamic>[];

    return list
        .whereType<Map>()
        .map(
          (e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  /// Get unread notification count
  Future<int> unreadCount() async {
    final response = await _dio.get("notifications/unread-count");
    final raw = response.data;

    final unread = raw is Map
        ? (raw["data"] is Map ? raw["data"]["unread"] : raw["unread"])
        : raw;

    if (unread is int) return unread;
    return int.tryParse(unread?.toString() ?? '') ?? 0;
  }

  /// Mark a single notification as read
  Future<void> markRead(String id) async {
    await _dio.put("notifications/$id/read");
  }

  /// Mark all notifications as read
  Future<void> markAllRead() async {
    await _dio.put("notifications/read-all");
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    await _dio.delete("notifications/$id");
  }
}
