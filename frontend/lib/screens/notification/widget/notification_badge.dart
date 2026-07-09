import 'package:flutter/material.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:get/get.dart';


class NotificationBadge extends GetView<NotificationController> {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.toNamed(AppRoutes.notifications);
            },
          ),

          if (controller.unreadCount.value > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minHeight: 18,
                  minWidth: 18,
                ),
                child: Center(
                  child: Text(
                    controller.unreadCount.value > 99
                        ? "99+"
                        : controller.unreadCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}