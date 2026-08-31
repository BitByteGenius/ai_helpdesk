import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/notification/widget/notification_tile.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Notifications',
      actions: [
        Obx(() {
          if (controller.unreadCount.value > 0) {
            return TextButton.icon(
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text("Mark all read", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              onPressed: controller.markAllRead,
            );
          }
          return const SizedBox.shrink();
        }),
        const SizedBox(width: 8),
      ],
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "All caught up!",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "You don't have any pending notifications right now.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity Alerts (${controller.unreadCount.value} unread)",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.notifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final notification = controller.notifications[index];
                          return NotificationTile(
                            notification: notification,
                            onTap: () async {
                              if (!notification.isRead) {
                                await controller.markRead(notification.id);
                              }
                            },
                            onDelete: () async {
                              await controller.deleteNotification(notification.id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}