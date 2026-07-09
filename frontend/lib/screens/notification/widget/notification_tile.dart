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

  IconData getIcon() {
    switch (notification.type) {
      case "ticket":
        return Icons.confirmation_number;

      case "assignment":
        return Icons.assignment_ind;

      case "status":
        return Icons.update;

      case "comment":
        return Icons.comment;

      case "security":
        return Icons.security;

      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead
          ? Colors.white
          : Colors.blue.shade50,
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          child: Icon(getIcon()),
        ),

        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),

        subtitle: Text(notification.message),

        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}