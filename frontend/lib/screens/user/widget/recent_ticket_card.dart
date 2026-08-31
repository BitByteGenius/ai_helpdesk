import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentTicketCard extends StatelessWidget {
  final TicketModel? ticket;

  const RecentTicketCard({
    super.key,
    this.ticket,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return AppColors.warning;
      case "assigned":
        return AppColors.info;
      case "in progress":
        return AppColors.purple;
      case "resolved":
        return AppColors.success;
      case "closed":
        return const Color(0xFF64748B);
      case "rejected":
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "critical":
        return AppColors.error;
      case "high":
        return const Color(0xFFF97316);
      case "medium":
        return AppColors.warning;
      case "low":
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = ticket?.status ?? "Open";
    final priority = ticket?.priority ?? "Medium";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (ticket != null) {
            Get.toNamed(
              AppRoutes.userTicketDetails,
              arguments: ticket!.id,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
            boxShadow: context.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Title & Status ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ticket?.title ?? "Unable to Login",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _pill(status, _statusColor(status)),
                ],
              ),

              const SizedBox(height: 8),

              // ── Description ──
              Expanded(
                child: Text(
                  ticket?.description ?? "No description provided.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Footer: Priority & Date ──
              Row(
                children: [
                  _pill(priority, _priorityColor(priority)),
                  const Spacer(),
                  Text(
                    ticket == null
                        ? "-"
                        : DateFormat("dd MMM yyyy").format(ticket!.createdAt),
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
