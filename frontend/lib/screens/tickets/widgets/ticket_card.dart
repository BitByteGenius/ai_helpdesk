import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:intl/intl.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
        boxShadow: context.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ticket.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TicketStatusChip(status: ticket.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    PriorityChip(priority: ticket.priority),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: context.surfaceSubtle,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ticket.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat("dd MMM yyyy").format(ticket.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 8),
                  Divider(height: 16, color: context.borderLight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.visibility_outlined, size: 14),
                        label: const Text("View Details", style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.error),
                        label: const Text("Delete", style: TextStyle(fontSize: 12, color: AppColors.error)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}