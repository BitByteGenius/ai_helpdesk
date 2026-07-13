import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';

import 'priority_chip.dart';
import 'ticket_status_chip.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isAdmin;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onDelete,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              ticket.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                TicketStatusChip(
                  status: ticket.status,
                ),
                const SizedBox(width: 10),
                PriorityChip(
                  priority: ticket.priority,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: [

                TextButton(
                  onPressed: onTap,
                  child: const Text("View"),
                ),

                if (isAdmin)
                  TextButton(
                    onPressed: onDelete,
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}