// import 'package:flutter/material.dart';
// import 'package:frontend/models/notification_model.dart';


// class NotificationTile extends StatelessWidget {
//   final NotificationModel notification;
//   final VoidCallback? onTap;
//   final VoidCallback? onDelete;

//   const NotificationTile({
//     super.key,
//     required this.notification,
//     this.onTap,
//     this.onDelete,
//   });

//   IconData getIcon() {
//     switch (notification.type) {
//       case "ticket":
//         return Icons.confirmation_number;

//       case "assignment":
//         return Icons.assignment_ind;

//       case "status":
//         return Icons.update;

//       case "comment":
//         return Icons.comment;

//       case "security":
//         return Icons.security;

//       default:
//         return Icons.notifications;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: notification.isRead
//           ? Colors.white
//           : Colors.blue.shade50,
//       child: ListTile(
//         onTap: onTap,

//         leading: CircleAvatar(
//           child: Icon(getIcon()),
//         ),

//         title: Text(
//           notification.title,
//           style: TextStyle(
//             fontWeight: notification.isRead
//                 ? FontWeight.normal
//                 : FontWeight.bold,
//           ),
//         ),

//         subtitle: Text(notification.message),

//         trailing: IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: onDelete,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDelete,
  });

  IconData _getIcon() {
    switch (notification.type.toLowerCase()) {
      case "ticket":
        return Icons.confirmation_number_outlined;
      case "assignment":
        return Icons.assignment_ind_outlined;
      case "status":
        return Icons.published_with_changes_rounded;
      case "comment":
        return Icons.chat_bubble_outline_rounded;
      case "security":
        return Icons.shield_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getTypeColor() {
    switch (notification.type.toLowerCase()) {
      case "ticket":
        return AppColors.primary;
      case "assignment":
        return AppColors.purple;
      case "status":
        return AppColors.warning;
      case "comment":
        return AppColors.info;
      case "security":
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.card : AppColors.primarySubtle.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                if (!notification.isRead)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: Container(color: AppColors.primary),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_getIcon(), size: 20, color: typeColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat("hh:mm a").format(notification.createdAt),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        tooltip: "Dismiss",
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}