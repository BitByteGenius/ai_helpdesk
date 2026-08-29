import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../../models/audit_model.dart';

class AuditTimelineCard extends StatelessWidget {
  final List<AuditModel> audits;

  const AuditTimelineCard({
    super.key,
    required this.audits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Audit Timeline",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (audits.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No activity available.",
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: audits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final audit = audits[index];
                final isLast = index == audits.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _color(audit.action).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: _color(audit.action).withValues(alpha: 0.3), width: 1.5),
                            ),
                            child: Icon(
                              _icon(audit.action),
                              color: _color(audit.action),
                              size: 15,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: AppColors.borderLight,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      audit.action,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd MMM • hh:mm a").format(audit.createdAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                audit.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline_rounded, size: 12, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    audit.user.name,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  IconData _icon(String action) {
    switch (action.toLowerCase()) {
      case "created":
        return Icons.add_circle_outline_rounded;
      case "assigned":
        return Icons.assignment_ind_outlined;
      case "status changed":
        return Icons.sync_rounded;
      case "resolved":
        return Icons.check_circle_outline_rounded;
      case "closed":
        return Icons.lock_outline_rounded;
      case "comment":
        return Icons.chat_bubble_outline_rounded;
      case "ai_analysis":
        return Icons.auto_awesome_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  Color _color(String action) {
    switch (action.toLowerCase()) {
      case "created":
        return AppColors.success;
      case "assigned":
        return AppColors.primary;
      case "status changed":
        return AppColors.warning;
      case "resolved":
        return AppColors.success;
      case "closed":
        return const Color(0xFF64748B);
      case "comment":
        return AppColors.purple;
      case "ai_analysis":
        return AppColors.accent;
      default:
        return AppColors.secondary;
    }
  }
}