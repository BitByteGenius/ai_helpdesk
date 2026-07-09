import 'package:flutter/material.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/notification/widget/notification_tile.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';

class NotificationScreen
    extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Notifications',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("No notifications"),
          );
        }

        return ListView.builder(
          itemCount:
              controller.notifications.length,
          itemBuilder: (_, index) {
            final notification =
                controller.notifications[index];

            return NotificationTile(
              notification: notification,

              onTap: () async {
                if (!notification.isRead) {
                  await controller.markRead(
                    notification.id,
                  );
                }
              },

              onDelete: () async {
                await controller
                    .deleteNotification(
                  notification.id,
                );
              },
            );
          },
        );
      }),
    );
  }
}
