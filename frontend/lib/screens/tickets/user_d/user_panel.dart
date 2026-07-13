import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:intl/intl.dart';

class UserPanel extends StatelessWidget {
  final TicketModel ticket;

  const UserPanel({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [

        /// Ticket Status
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor: _statusColor(ticket.status)
                      .withValues(alpha: .15),
                  child: Icon(
                    _statusIcon(ticket.status),
                    color: _statusColor(ticket.status),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Current Status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        ticket.status,
                        style: TextStyle(
                          color: _statusColor(ticket.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        /// Assigned Engineer
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  ticket.assignedTo?.profileImage.isNotEmpty == true
                      ? NetworkImage(
                          ticket.assignedTo!.profileImage,
                        )
                      : null,
              child: ticket.assignedTo == null
                  ? const Icon(Icons.person)
                  : null,
            ),

            title: Text(
              ticket.assignedTo?.name ??
                  "Awaiting Assignment",
            ),

            subtitle: Text(
              ticket.assignedTo?.email ??
                  "Support team will assign an engineer soon.",
            ),
          ),
        ),

        const SizedBox(height: 18),

        /// Ticket Information
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [

                _infoRow(
                  "Category",
                  ticket.category,
                ),

                const Divider(),

                _infoRow(
                  "Priority",
                  ticket.priority,
                ),

                const Divider(),

                _infoRow(
                  "Created",
                  DateFormat(
                    "dd MMM yyyy, hh:mm a",
                  ).format(ticket.createdAt),
                ),

                const Divider(),

                _infoRow(
                  "Updated",
                  DateFormat(
                    "dd MMM yyyy, hh:mm a",
                  ).format(ticket.updatedAt),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        /// Support Information
        Card(
          color: Colors.blue.shade50,
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Our support team is actively reviewing your ticket. "
                    "You'll receive updates here whenever the status changes "
                    "or an engineer replies.",
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Row(
      children: [

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {

      case "open":
        return Colors.green;

      case "assigned":
        return Colors.blue;

      case "in progress":
        return Colors.orange;

      case "resolved":
        return Colors.teal;

      case "closed":
        return Colors.grey;

      default:
        return Colors.black54;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {

      case "open":
        return Icons.mark_email_unread;

      case "assigned":
        return Icons.assignment_ind;

      case "in progress":
        return Icons.engineering;

      case "resolved":
        return Icons.check_circle;

      case "closed":
        return Icons.lock;

      default:
        return Icons.help;
    }
  }
}