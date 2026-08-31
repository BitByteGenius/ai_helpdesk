import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/dashboard_model.dart';

class AiInsightsCard extends StatelessWidget {
  final AiInsights insights;

  const AiInsightsCard({
    super.key,
    required this.insights,
  });

  Widget _metric({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: context.isDark ? 0.25 : 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: context.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "AI Insights & Intelligence",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (_, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(
                      child: _metric(
                        context: context,
                        icon: Icons.psychology_rounded,
                        title: "AI Analyses",
                        value: insights.totalAnalysis.toString(),
                        color: AppColors.primary,
                        subtitle: "Total tickets triaged",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _metric(
                        context: context,
                        icon: Icons.copy_all_rounded,
                        title: "Duplicate Tickets",
                        value: insights.duplicates.toString(),
                        color: AppColors.warning,
                        subtitle: "Clustered & linked",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _metric(
                        context: context,
                        icon: Icons.quickreply_rounded,
                        title: "Suggested Replies",
                        value: insights.suggestedReplies.toString(),
                        color: AppColors.success,
                        subtitle: "Generated copilot drafts",
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _metric(
                    context: context,
                    icon: Icons.psychology_rounded,
                    title: "AI Analyses",
                    value: insights.totalAnalysis.toString(),
                    color: AppColors.primary,
                    subtitle: "Total tickets triaged",
                  ),
                  const SizedBox(height: 10),
                  _metric(
                    context: context,
                    icon: Icons.copy_all_rounded,
                    title: "Duplicate Tickets",
                    value: insights.duplicates.toString(),
                    color: AppColors.warning,
                    subtitle: "Clustered & linked",
                  ),
                  const SizedBox(height: 10),
                  _metric(
                    context: context,
                    icon: Icons.quickreply_rounded,
                    title: "Suggested Replies",
                    value: insights.suggestedReplies.toString(),
                    color: AppColors.success,
                    subtitle: "Generated copilot drafts",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}