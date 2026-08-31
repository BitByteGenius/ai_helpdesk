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
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticket.assignedTo?.email ?? "Support team will assign an engineer soon.",
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary,
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
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _infoRow(context, "Category", ticket.category),
              Divider(color: context.borderLight, height: 16),
              _infoRow(context, "Priority", ticket.priority),
              Divider(color: context.borderLight, height: 16),
              _infoRow(context, "Created", DateFormat("dd MMM yyyy, hh:mm a").format(ticket.createdAt)),
              Divider(color: context.borderLight, height: 16),
              _infoRow(context, "Updated", DateFormat("dd MMM yyyy, hh:mm a").format(ticket.updatedAt)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Helpdesk SLA Info ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.primarySubtle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: context.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Our support team is actively reviewing your ticket. You'll receive updates here whenever the status changes or an engineer replies.",
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 12,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: context.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }
}