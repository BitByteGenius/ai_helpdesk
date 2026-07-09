import 'package:dio/dio.dart';

import '../models/notification_model.dart';

class NotificationService {
  final Dio _dio;

  NotificationService(this._dio);

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
          (e) => NotificationModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  Future<int> unreadCount() async {
    final response = await _dio.get("notifications/unread-count");
    final raw = response.data;

    final unread = raw is Map
        ? (raw["data"] is Map
            ? raw["data"]["unread"]
            : raw["unread"])
        : raw;

    if (unread is int) return unread;
    return int.tryParse(unread?.toString() ?? '') ?? 0;
  }

  Future<void> markRead(String id) async {
    await _dio.put(
      "notifications/$id/read",
    );
  }

  Future<void> markAllRead() async {
    await _dio.put(
      "notifications/read-all",
    );
  }

  Future<void> deleteNotification(
      String id) async {
    await _dio.delete(
      "notifications/$id",
    );
  }
}
