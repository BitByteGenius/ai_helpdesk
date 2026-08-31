import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class DashboardStats extends GetView<TicketController> {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1100 ? 4 : width >= 640 ? 2 : 1;
        final childAspectRatio = width >= 1100 ? 2.4 : width >= 640 ? 2.6 : 2.8;

        return Obx(() {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
            children: [
              _StatCard(
                title: "Total Tickets",
                value: controller.totalTicketsCount.toString(),
                icon: Icons.confirmation_number_rounded,
                color: AppColors.info,
              ),
              _StatCard(
                title: "Open",
                value: controller.openTicketsCount.toString(),
                icon: Icons.pending_actions_rounded,
                color: AppColors.warning,
              ),
              _StatCard(
                title: "In Progress",
                value: controller.inProgressTicketsCount.toString(),
                icon: Icons.sync_rounded,
                color: AppColors.purple,
              ),
              _StatCard(
                title: "Resolved",
                value: controller.resolvedTicketsCount.toString(),
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
              ),
            ],
          );
        });
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: context.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
