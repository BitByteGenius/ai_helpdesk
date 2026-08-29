import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
    return Column(
      children: [
        // ── Assigned Engineer ──
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.purple.withValues(alpha: 0.15),
                backgroundImage: ticket.assignedTo?.profileImage.isNotEmpty == true
                    ? NetworkImage(ticket.assignedTo!.profileImage)
                    : null,
                child: ticket.assignedTo == null
                    ? const Icon(Icons.person_outline_rounded, color: AppColors.purple, size: 20)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.assignedTo?.name ?? "Awaiting Assignment",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticket.assignedTo?.email ?? "Support team will assign an engineer soon.",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Ticket Details Summary ──
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _infoRow("Category", ticket.category),
              const Divider(color: AppColors.borderLight, height: 16),
              _infoRow("Priority", ticket.priority),
              const Divider(color: AppColors.borderLight, height: 16),
              _infoRow("Created", DateFormat("dd MMM yyyy, hh:mm a").format(ticket.createdAt)),
              const Divider(color: AppColors.borderLight, height: 16),
              _infoRow("Updated", DateFormat("dd MMM yyyy, hh:mm a").format(ticket.updatedAt)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Helpdesk SLA Info ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Our support team is actively reviewing your ticket. You'll receive updates here whenever the status changes or an engineer replies.",
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}