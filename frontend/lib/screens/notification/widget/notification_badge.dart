// import 'package:flutter/material.dart';
// import 'package:frontend/controllers/notification_controller.dart';
// import 'package:frontend/core/routes/app_routes.dart';
// import 'package:get/get.dart';


// class NotificationBadge extends GetView<NotificationController> {
//   const NotificationBadge({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Stack(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined),
//             onPressed: () {
//               Get.toNamed(AppRoutes.notifications);
//             },
//           ),

//           if (controller.unreadCount.value > 0)
//             Positioned(
//               right: 8,
//               top: 8,
//               child: Container(
//                 padding: const EdgeInsets.all(5),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 constraints: const BoxConstraints(
//                   minHeight: 18,
//                   minWidth: 18,
//                 ),
//                 child: Center(
//                   child: Text(
//                     controller.unreadCount.value > 99
//                         ? "99+"
//                         : controller.unreadCount.value.toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       );
//     });
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class NotificationBadge extends GetView<NotificationController> {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.unreadCount.value;

      return Badge(
        label: Text(count > 99 ? "99+" : count.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        isLabelVisible: count > 0,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        offset: const Offset(-2, 2),
        child: IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 20),
          tooltip: "Notifications",
          onPressed: () {
            Get.toNamed(AppRoutes.notifications);
          },
        ),
      );
    });
  }
}