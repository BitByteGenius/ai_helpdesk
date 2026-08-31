import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/audit/widget/audit_filter.dart';
import 'package:frontend/screens/audit/widget/audit_table.dart';
import 'package:get/get.dart';

class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuditController>();

    return AdminLayout(
      title: 'Audit Logs',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh Audit Logs',
          onPressed: controller.fetchAudits,
        ),
        const SizedBox(width: 8),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1100;
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return RefreshIndicator(
            onRefresh: controller.fetchAudits,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header Title & Subtitle ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                            ),
                            child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "System Audit Trails",
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.4,
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.successSubtle,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.lock_clock_rounded, size: 12, color: AppColors.success),
                                          SizedBox(width: 4),
                                          Text(
                                            "IMMUTABLE LOGS",
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.success),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Real-time compliance monitoring, user authentication history, entity state mutations, and AI telemetry.",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Metric KPI Cards ──
                      Obx(() {
                        final audits = controller.audits;
                        final total = audits.length;
                        final authCount = audits.where((a) => a.action == "LOGIN" || a.action == "REGISTER").length;
                        final mutationsCount = audits.where((a) => a.action == "CREATE" || a.action == "UPDATE" || a.action == "DELETE" || a.action == "STATUS_CHANGE" || a.action == "ASSIGN").length;
                        final aiCount = audits.where((a) => a.action == "AI_ANALYSIS" || a.entity == "AI").length;

                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(child: _buildMetricCard(title: "Total Logged Events", value: "$total", icon: Icons.receipt_long_rounded, color: AppColors.primary)),
                              const SizedBox(width: 14),
                              Expanded(child: _buildMetricCard(title: "Auth & Security", value: "$authCount", icon: Icons.verified_user_rounded, color: AppColors.success)),
                              const SizedBox(width: 14),
                              Expanded(child: _buildMetricCard(title: "Data Mutations", value: "$mutationsCount", icon: Icons.swap_horiz_rounded, color: AppColors.warning)),
                              const SizedBox(width: 14),
                              Expanded(child: _buildMetricCard(title: "AI & Automations", value: "$aiCount", icon: Icons.auto_awesome_rounded, color: AppColors.purple)),
                            ],
                          );
                        } else {
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(width: constraints.maxWidth > 500 ? (constraints.maxWidth - 12) / 2 : double.infinity, child: _buildMetricCard(title: "Total Events", value: "$total", icon: Icons.receipt_long_rounded, color: AppColors.primary)),
                              SizedBox(width: constraints.maxWidth > 500 ? (constraints.maxWidth - 12) / 2 : double.infinity, child: _buildMetricCard(title: "Auth Events", value: "$authCount", icon: Icons.verified_user_rounded, color: AppColors.success)),
                              SizedBox(width: constraints.maxWidth > 500 ? (constraints.maxWidth - 12) / 2 : double.infinity, child: _buildMetricCard(title: "Mutations", value: "$mutationsCount", icon: Icons.swap_horiz_rounded, color: AppColors.warning)),
                              SizedBox(width: constraints.maxWidth > 500 ? (constraints.maxWidth - 12) / 2 : double.infinity, child: _buildMetricCard(title: "AI Actions", value: "$aiCount", icon: Icons.auto_awesome_rounded, color: AppColors.purple)),
                            ],
                          );
                        }
                      }),
                      const SizedBox(height: 24),

                      // ── Filter Section ──
                      const AuditFilter(),
                      const SizedBox(height: 20),

                      // ── Main Audit Table / List ──
                      const AuditTable(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


