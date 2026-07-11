// import 'package:flutter/material.dart';
// import 'package:frontend/layouts/user_layout.dart';
// import 'package:frontend/screens/notification/widget/notification_tile.dart';
// import 'package:get/get.dart';

// import '../../controllers/notification_controller.dart';

// class NotificationScreen
//     extends GetView<NotificationController> {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return UserLayout(
//       title: 'Notifications',
//       child: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (controller.notifications.isEmpty) {
//           return const Center(
//             child: Text("No notifications"),
//           );
//         }

//         return ListView.builder(
//           itemCount:
//               controller.notifications.length,
//           itemBuilder: (_, index) {
//             final notification =
//                 controller.notifications[index];

//             return NotificationTile(
//               notification: notification,

//               onTap: () async {
//                 if (!notification.isRead) {
//                   await controller.markRead(
//                     notification.id,
//                   );
//                 }
//               },

//               onDelete: () async {
//                 await controller
//                     .deleteNotification(
//                   notification.id,
//                 );
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/notification/widget/notification_tile.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return UserLayout(
      title: 'Notifications',
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
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  "All caught up!",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You don't have any notifications right now.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              slivers: [
                // Clean Action Header Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Alerts (${controller.unreadCount.value} unread)",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (controller.unreadCount.value > 0)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                            ),
                            icon: const Icon(Icons.done_all, size: 18),
                            label: const Text("Mark all read"),
                            onPressed: controller.markAllRead,
                          ),
                      ],
                    ),
                  ),
                ),
                // Responsive Scroll List
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24.0 : 12.0,
                    vertical: 8.0,
                  ),
                  sliver: SliverList.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NotificationTile(
                          notification: notification,
                          onTap: () async {
                            if (!notification.isRead) {
                              await controller.markRead(notification.id);
                            }
                          },
                          onDelete: () async {
                            await controller.deleteNotification(notification.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}