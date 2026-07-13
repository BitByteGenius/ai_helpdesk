import 'package:flutter/material.dart';

class TicketStatusChip extends StatelessWidget {
  final String status;

  const TicketStatusChip({
    super.key,
    required this.status,
  });

  Color get backgroundColor {
    switch (status) {
      case "Open":
        return Colors.orange.shade100;

      case "Assigned":
        return Colors.blue.shade100;

      case "In Progress":
        return Colors.purple.shade100;

      case "Resolved":
        return Colors.green.shade100;

      case "Closed":
        return Colors.grey.shade300;

      case "Rejected":
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color get textColor {
    switch (status) {
      case "Open":
        return Colors.orange.shade900;

      case "Assigned":
        return Colors.blue.shade900;

      case "In Progress":
        return Colors.purple.shade900;

      case "Resolved":
        return Colors.green.shade900;

      case "Closed":
        return Colors.black87;

      case "Rejected":
        return Colors.red.shade900;

      default:
        return Colors.black87;
    }
  }

  IconData get icon {
    switch (status) {
      case "Open":
        return Icons.pending_actions;

      case "Assigned":
        return Icons.person;

      case "In Progress":
        return Icons.autorenew;

      case "Resolved":
        return Icons.check_circle;

      case "Closed":
        return Icons.lock;

      case "Rejected":
        return Icons.cancel;

      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: textColor,
      ),
      label: Text(
        status,
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