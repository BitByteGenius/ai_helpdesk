import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class TicketStatusChip extends StatelessWidget {
  final String status;

  const TicketStatusChip({
    super.key,
    required this.status,
  });

  Color get _color {
    switch (status.toLowerCase()) {
      case "open":
        return AppColors.warning;
      case "assigned":
        return AppColors.info;
      case "in progress":
        return AppColors.purple;
      case "resolved":
        return AppColors.success;
      case "closed":
        return const Color(0xFF64748B);
      case "rejected":
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case "open":
        return Icons.pending_actions_rounded;
      case "assigned":
        return Icons.person_rounded;
      case "in progress":
        return Icons.autorenew_rounded;
      case "resolved":
        return Icons.check_circle_rounded;
      case "closed":
        return Icons.lock_outline_rounded;
      case "rejected":
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}