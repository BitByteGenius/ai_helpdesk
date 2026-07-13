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
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Admin Actions",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Assign to Me Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.assignment_ind, size: 18),
                  label: const Text("Assign to Me"),
                  onPressed: () {
                    controller.assignTicket(ticket.id);
                  },
                ),

                // In Progress Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: const Text("In Progress"),
                  onPressed: () {
                    controller.updateStatus(ticket.id, "In Progress");
                  },
                ),

                // Resolve Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text("Resolve"),
                  onPressed: () {
                    controller.updateStatus(ticket.id, "Resolved");
                  },
                ),

                // Close Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.lock_outline, size: 18),
                  label: const Text("Close"),
                  onPressed: () {
                    controller.updateStatus(ticket.id, "Closed");
                  },
                ),

                // Delete Button (Red / destructive style)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                    foregroundColor: theme.colorScheme.onErrorContainer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text("Delete"),
                  onPressed: () {
                    _confirmDelete(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Ticket",
      middleText: "Are you sure you want to permanently delete this ticket?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // close dialog
        await controller.deleteTicket(ticket.id);
        Get.back(); // go back to ticket list screen
      },
    );
  }
}