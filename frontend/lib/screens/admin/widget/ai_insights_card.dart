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
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "AI Insights & Intelligence",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
                    icon: Icons.psychology_rounded,
                    title: "AI Analyses",
                    value: insights.totalAnalysis.toString(),
                    color: AppColors.primary,
                    subtitle: "Total tickets triaged",
                  ),
                  const SizedBox(height: 10),
                  _metric(
                    icon: Icons.copy_all_rounded,
                    title: "Duplicate Tickets",
                    value: insights.duplicates.toString(),
                    color: AppColors.warning,
                    subtitle: "Clustered & linked",
                  ),
                  const SizedBox(height: 10),
                  _metric(
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