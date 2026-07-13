import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/ticket_controller.dart';
import '../../../../models/ticket_model.dart';

class AdminActionsCard extends GetView<TicketController> {
  final TicketModel ticket;

  const AdminActionsCard({
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
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Admin Actions",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [

                FilledButton.icon(
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text("Assign"),
                  onPressed: () {
                    _showAssignDialog(context);
                  },
                ),

                FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("In Progress"),
                  onPressed: () {
                    controller.updateStatus(
                      ticketId: ticket.id,
                      status: "In Progress",
                    );
                  },
                ),

                FilledButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Resolve"),
                  onPressed: () {
                    controller.updateStatus(
                      ticketId: ticket.id,
                      status: "Resolved",
                    );
                  },
                ),

                FilledButton.icon(
                  icon: const Icon(Icons.lock),
                  label: const Text("Close"),
                  onPressed: () {
                    controller.updateStatus(
                      ticketId: ticket.id,
                      status: "Closed",
                    );
                  },
                ),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () {
                    _deleteDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteDialog() {
    Get.defaultDialog(
      title: "Delete Ticket",
      middleText:
          "Are you sure you want to permanently delete this ticket?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();

        await controller.deleteTicket(ticket.id);

        Get.back();
      },
    );
  }

  void _showAssignDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Assign Ticket",
      middleText:
          "Implement your employee selection dialog here.",
      textConfirm: "Assign",
      textCancel: "Cancel",
      onConfirm: () {
        Get.back();

        /// Example
        /// controller.assignTicket(
        ///    ticketId: ticket.id,
        ///    userId: selectedEmployeeId,
        /// );
      },
    );
  }
}