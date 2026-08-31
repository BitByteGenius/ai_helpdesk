import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/admin_layout.dart';

class AdminAiScreen extends StatelessWidget {
  const AdminAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'AI Copilot Management',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Copilot & Smart Routing",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: context.textPrimary,
                          ) ??
                          TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: context.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Monitor automated ticket categorization, priority prediction, and LLM copilot status across your organization.",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status banner
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: context.isDark ? 0.16 : 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI Services Operational",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: context.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Real-time ticket analysis, automated duplicate detection, and conversational copilot are running normally.",
                                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Feature highlights
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Active AI Capabilities",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: context.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureRow(
                            context: context,
                            icon: Icons.auto_awesome_rounded,
                            title: "Smart Categorization & Priority",
                            description: "Automatically analyzes incoming user tickets and assigns appropriate categories and SLA priorities.",
                          ),
                          Divider(height: 24, color: context.borderLight),
                          _buildFeatureRow(
                            context: context,
                            icon: Icons.content_copy_rounded,
                            title: "Duplicate Ticket Detection",
                            description: "Detects similar pending tickets submitted across departments to prevent duplicate engineering effort.",
                          ),
                          Divider(height: 24, color: context.borderLight),
                          _buildFeatureRow(
                            context: context,
                            icon: Icons.chat_bubble_outline_rounded,
                            title: "Interactive User Support Copilot",
                            description: "Provides instant conversational troubleshooting and automatically drafts tickets with transcripts.",
                          ),
                          Divider(height: 24, color: context.borderLight),
                          _buildFeatureRow(
                            context: context,
                            icon: Icons.reply_all_rounded,
                            title: "Agent Suggested Replies & Root Cause",
                            description: "Generates one-click reply drafts and estimated root causes for engineers inside ticket details.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primarySubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: context.primaryColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: context.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 12.5, color: context.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
