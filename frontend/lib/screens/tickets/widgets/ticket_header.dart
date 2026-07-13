import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';

class TicketHeader extends StatelessWidget {
  final TicketModel ticket;

  const TicketHeader({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Ticket ID + Badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Ticket #${ticket.id.substring(ticket.id.length - 6).toUpperCase()}",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(
                      ticket.category,
                      Colors.blue,
                    ),
                    _chip(
                      ticket.priority,
                      _priorityColor(ticket.priority),
                    ),
                    _chip(
                      ticket.status,
                      _statusColor(ticket.status),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              ticket.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              ticket.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _UserInfo(
                    title: "Created By",
                    name: ticket.createdBy.name,
                    email: ticket.createdBy.email,
                    image: ticket.createdBy.profileImage,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _UserInfo(
                    title: "Assigned To",
                    name: ticket.assignedTo?.name ?? "Unassigned",
                    email:
                        ticket.assignedTo?.email ??
                        "No agent assigned",
                    image:
                        ticket.assignedTo?.profileImage ??
                        "",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: .35),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "critical":
        return Colors.red;
      case "high":
        return Colors.orange;
      case "medium":
        return Colors.blue;
      default:
        return Colors.green;
    }
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
}

class _UserInfo extends StatelessWidget {
  final String title;
  final String name;
  final String email;
  final String image;

  const _UserInfo({
    required this.title,
    required this.name,
    required this.email,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage:
              image.isNotEmpty ? NetworkImage(image) : null,
          child: image.isEmpty
              ? Text(
                  name.isNotEmpty
                      ? name[0].toUpperCase()
                      : "?",
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 3),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}