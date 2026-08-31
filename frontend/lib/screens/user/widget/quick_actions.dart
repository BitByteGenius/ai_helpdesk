import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 900 ? 4 : width >= 600 ? 2 : 1;
            final childAspectRatio = width >= 900 ? 2.2 : width >= 600 ? 2.5 : 3.0;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              children: const [
                _ActionCard(
                  title: "Create Ticket",
                  subtitle: "Raise a new support issue",
                  icon: Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                  route: AppRoutes.createTicket,
                ),
                _ActionCard(
                  title: "My Tickets",
                  subtitle: "Track your active tickets",
                  icon: Icons.confirmation_number_outlined,
                  color: AppColors.warning,
                  route: AppRoutes.myTickets,
                ),
                _ActionCard(
                  title: "AI Assistant",
                  subtitle: "Instant AI copilot triage",
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.purple,
                  route: AppRoutes.aiAssistant,
                ),
                _ActionCard(
                  title: "Profile",
                  subtitle: "Manage security & settings",
                  icon: Icons.person_outline_rounded,
                  color: AppColors.success,
                  route: AppRoutes.profile,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: context.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
