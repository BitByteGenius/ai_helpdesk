import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PriorityChip extends StatelessWidget {
  final String priority;

  const PriorityChip({
    super.key,
    required this.priority,
  });

  Color get _color {
    switch (priority.toLowerCase()) {
      case "critical":
        return AppColors.error;
      case "high":
        return const Color(0xFFF97316);
      case "medium":
        return AppColors.warning;
      case "low":
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }

  IconData get _icon {
    switch (priority.toLowerCase()) {
      case "critical":
        return Icons.priority_high_rounded;
      case "high":
        return Icons.arrow_upward_rounded;
      case "medium":
        return Icons.remove_rounded;
      case "low":
        return Icons.arrow_downward_rounded;
      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            priority,
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