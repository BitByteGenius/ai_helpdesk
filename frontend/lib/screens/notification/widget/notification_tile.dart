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
import 'package:frontend/models/notification_model.dart';

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
    switch (notification.type) {
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

  Color _getTypeColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (notification.type) {
      case "ticket":
        return theme.colorScheme.primary;
      case "assignment":
        return Colors.purple;
      case "status":
        return Colors.orange;
      case "comment":
        return Colors.teal;
      case "security":
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead
              ? theme.colorScheme.surface
              : theme.colorScheme.primaryContainer.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? theme.colorScheme.outlineVariant.withOpacity(0.4)
                : theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Left Vertical Unread Highlight Accent Bar
              if (!notification.isRead)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: Container(color: theme.colorScheme.primary),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Styled Avatar Icon Box
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(), size: 22, color: typeColor),
                    ),
                    const SizedBox(width: 16),
                    // Main Text Info Frame
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Action Context (Delete) Button
                    IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      tooltip: "Dismiss Alert",
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}