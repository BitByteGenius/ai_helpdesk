import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                color: context.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Admin Actions",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // Assign to Me Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: BorderSide(color: context.border),
                ),
                icon: Icon(Icons.assignment_ind_outlined, size: 16, color: context.primaryColor),
                label: const Text("Assign to Me", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                onPressed: () {
                  controller.assignTicket(ticket.id);
                },
              ),

              // In Progress Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: BorderSide(color: context.border),
                ),
                icon: const Icon(Icons.play_circle_outline, size: 16, color: AppColors.purple),
                label: const Text("In Progress", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                onPressed: () {
                  controller.updateStatus(ticket.id, "In Progress");
                },
              ),

              // Resolve Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: BorderSide(color: context.border),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                label: const Text("Resolve", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                onPressed: () {
                  controller.updateStatus(ticket.id, "Resolved");
                },
              ),

              // Close Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: BorderSide(color: context.border),
                ),
                icon: const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.secondary),
                label: const Text("Close", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                onPressed: () {
                  controller.updateStatus(ticket.id, "Closed");
                },
              ),

              // Delete Button (Red / destructive style)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                  backgroundColor: AppColors.error.withValues(alpha: context.isDark ? 0.15 : 0.08),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                label: const Text("Delete", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error)),
                onPressed: () {
                  _confirmDelete(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Ticket",
      titleStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: context.textPrimary),
      middleText: "Are you sure you want to permanently delete this ticket?",
      middleTextStyle: TextStyle(color: context.textSecondary, fontSize: 13),
      textConfirm: "Delete",
      textCancel: "Cancel",
      cancelTextColor: context.textPrimary,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      radius: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      titlePadding: const EdgeInsets.only(top: 24),
      onConfirm: () async {
        Get.back();
        await controller.deleteTicket(ticket.id);
        Get.back();
      },
    );
  }
}