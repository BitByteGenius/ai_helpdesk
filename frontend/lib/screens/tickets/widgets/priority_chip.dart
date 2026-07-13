import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final String priority;

  const PriorityChip({
    super.key,
    required this.priority,
  });

  Color get backgroundColor {
    switch (priority) {
      case "Low":
        return Colors.green.shade100;

      case "Medium":
        return Colors.blue.shade100;

      case "High":
        return Colors.orange.shade100;

      case "Critical":
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color get textColor {
    switch (priority) {
      case "Low":
        return Colors.green.shade900;

      case "Medium":
        return Colors.blue.shade900;

      case "High":
        return Colors.orange.shade900;

      case "Critical":
        return Colors.red.shade900;

      default:
        return Colors.black87;
    }
  }

  IconData get icon {
    switch (priority) {
      case "Low":
        return Icons.arrow_downward_rounded;

      case "Medium":
        return Icons.remove_rounded;

      case "High":
        return Icons.arrow_upward_rounded;

      case "Critical":
        return Icons.priority_high_rounded;

      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        color: textColor,
        size: 18,
      ),
      label: Text(
        priority,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide.none,
    );
  }
}