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

  Color _getTypeColor(BuildContext context) {
    switch (notification.type.toLowerCase()) {
      case "ticket":
        return context.primaryColor;
      case "assignment":
        return AppColors.purple;
      case "status":
        return AppColors.warning;
      case "comment":
        return AppColors.info;
      case "security":
        return AppColors.error;
      default:
        return context.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead ? context.cardBg : context.primarySubtle.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead ? context.border : context.primaryColor.withValues(alpha: 0.25),
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
                    child: Container(color: context.primaryColor),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: context.isDark ? 0.16 : 0.12),
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
                                      color: context.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat("hh:mm a").format(notification.createdAt),
                                  style: TextStyle(fontSize: 11, color: context.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: context.textMuted,
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