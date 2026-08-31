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
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Monitor automated ticket categorization, priority prediction, and LLM copilot status across your organization.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status banner
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.successSubtle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 28),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI Services Operational",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Real-time ticket analysis, automated duplicate detection, and conversational copilot are running normally.",
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Active AI Capabilities",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureRow(
                            icon: Icons.auto_awesome_rounded,
                            title: "Smart Categorization & Priority",
                            description: "Automatically analyzes incoming user tickets and assigns appropriate categories and SLA priorities.",
                          ),
                          const Divider(height: 24, color: AppColors.borderLight),
                          _buildFeatureRow(
                            icon: Icons.content_copy_rounded,
                            title: "Duplicate Ticket Detection",
                            description: "Detects similar pending tickets submitted across departments to prevent duplicate engineering effort.",
                          ),
                          const Divider(height: 24, color: AppColors.borderLight),
                          _buildFeatureRow(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: "Interactive User Support Copilot",
                            description: "Provides instant conversational troubleshooting and automatically drafts tickets with transcripts.",
                          ),
                          const Divider(height: 24, color: AppColors.borderLight),
                          _buildFeatureRow(
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

  Widget _buildFeatureRow({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

