import 'package:frontend/servicies/notification_service.dart';
import 'package:get/get.dart';

import '../controllers/socket_controller.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final NotificationService _service;

  NotificationController(this._service);

  final RxList<NotificationModel> notifications =
      <NotificationModel>[].obs;

  final RxInt unreadCount = 0.obs;

  final RxBool isLoading = false.obs;

  late SocketController socket;

  @override
  void onInit() {
    super.onInit();

    socket = Get.find<SocketController>();

    loadNotifications();

    socket.onNotification(_receiveNotification);
  }

  /// Fetch Notifications
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      notifications.assignAll(
        await _service.getNotifications(),
      );

      unreadCount.value =
          await _service.unreadCount();
    } finally {
      isLoading.value = false;
    }
  }

  /// Socket Event
  void _receiveNotification(dynamic data) {
    final notification =
        NotificationModel.fromJson(data);

    notifications.insert(0, notification);

    unreadCount.value++;
  }

  /// Mark Read
  Future<void> markRead(String id) async {
    await _service.markRead(id);

    final index = notifications.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        type: notifications[index].type,
        isRead: true,
        referenceId:
            notifications[index].referenceId,
        referenceModel:
            notifications[index].referenceModel,
        createdAt:
            notifications[index].createdAt,
      );
    }

    unreadCount.value =
        unreadCount.value > 0
            ? unreadCount.value - 1
            : 0;
  }

  /// Mark All Read
  Future<void> markAllRead() async {
    await _service.markAllRead();

    notifications.value = notifications
        .map(
          (e) => NotificationModel(
            id: e.id,
            title: e.title,
            message: e.message,
            type: e.type,
            isRead: true,
            referenceId: e.referenceId,
            referenceModel: e.referenceModel,
            createdAt: e.createdAt,
          ),
        )
        .toList();

    unreadCount.value = 0;
  }

  /// Delete Notification
  Future<void> deleteNotification(
      String id) async {
    await _service.deleteNotification(id);

    notifications.removeWhere(
      (e) => e.id == id,
    );

    unreadCount.value = notifications
        .where((e) => !e.isRead)
        .length;
  }

  @override
  void onClose() {
    socket.remove("notification");
    super.onClose();
  }
}
