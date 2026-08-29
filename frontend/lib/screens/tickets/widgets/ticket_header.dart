import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:intl/intl.dart';

import 'priority_chip.dart';
import 'ticket_status_chip.dart';

class TicketHeader extends StatelessWidget {
  final TicketModel ticket;

  const TicketHeader({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: ID & Badges ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#${ticket.id.length > 8 ? ticket.id.substring(ticket.id.length - 6).toUpperCase() : ticket.id.toUpperCase()}",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ticket.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              PriorityChip(priority: ticket.priority),
              const SizedBox(width: 8),
              TicketStatusChip(status: ticket.status),
            ],
          ),

          const SizedBox(height: 18),

          // ── Title ──
          Text(
            ticket.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 10),

          // ── Description ──
          Text(
            ticket.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),

          // ── User / Assignee Row ──
          Row(
            children: [
              Expanded(
                child: _UserInfo(
                  title: "Created By",
                  name: ticket.createdBy.name,
                  email: ticket.createdBy.email,
                  image: ticket.createdBy.profileImage,
                  date: ticket.createdAt,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _UserInfo(
                  title: "Assigned Engineer",
                  name: ticket.assignedTo?.name ?? "Unassigned",
                  email: ticket.assignedTo?.email ?? "Pending Assignment",
                  image: ticket.assignedTo?.profileImage ?? "",
                  date: ticket.updatedAt,
                  isAssignee: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String title;
  final String name;
  final String email;
  final String image;
  final DateTime date;
  final bool isAssignee;

  const _UserInfo({
    required this.title,
    required this.name,
    required this.email,
    required this.image,
    required this.date,
    this.isAssignee = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isAssignee ? AppColors.purple.withValues(alpha: 0.15) : AppColors.primarySubtle,
          backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
          child: image.isEmpty
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isAssignee ? AppColors.purple : AppColors.primary,
                    fontSize: 13,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat("dd MMM yyyy • hh:mm a").format(date),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}