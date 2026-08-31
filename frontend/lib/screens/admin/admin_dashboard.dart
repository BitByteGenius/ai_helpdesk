import 'package:flutter/material.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/models/dashboard_model.dart';
import 'package:frontend/screens/admin/widget/ai_insights_card.dart';
import 'package:frontend/screens/admin/widget/priority_chart.dart';
import 'package:frontend/screens/admin/widget/recent_tickets_table.dart';
import 'package:frontend/screens/admin/widget/recent_users_table.dart';
import 'package:frontend/screens/admin/widget/stat_card.dart';
import 'package:frontend/screens/admin/widget/ticket_status_chart.dart';
import 'package:get/get.dart';

class AdminDashboard extends GetView<DashboardController> {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Admin Dashboard',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh Dashboard',
          onPressed: controller.refreshDashboard,
        ),
        const SizedBox(width: 8),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.hasError.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: controller.refreshDashboard,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Try Again"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final dashboard = controller.dashboard.value;

            if (dashboard == null) {
              return const Center(
                child: Text("No Data Available"),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header Title Block ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Overview",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Monitor tickets, users, AI insights and support activity in real time.",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Stat Cards Grid ──
                    LayoutBuilder(
                      builder: (context, gridConstraints) {
                        final availableWidth = gridConstraints.maxWidth;
                        final crossAxisCount = availableWidth >= 1200
                            ? 4
                            : availableWidth >= 700
                                ? 2
                                : 1;
                        final childAspectRatio = availableWidth >= 1200
                            ? 1.6
                            : availableWidth >= 700
                                ? 1.65
                                : 2.2;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemBuilder: (context, index) {
                            return StatCard(
                              title: _statTitles[index],
                              value: _statValues(dashboard)[index],
                              icon: _statIcons[index],
                              color: _statColors[index],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ── Charts Row / Column ──
                    LayoutBuilder(
                      builder: (context, chartConstraints) {
                        final isWide = chartConstraints.maxWidth >= 900;

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 340,
                                  child: TicketStatusChart(
                                    statusData: dashboard.ticketStatus,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 340,
                                  child: PriorityChart(
                                    priorityData: dashboard.priority,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: 320,
                              child: TicketStatusChart(
                                statusData: dashboard.ticketStatus,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 320,
                              child: PriorityChart(
                                priorityData: dashboard.priority,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── AI Insights Card ──
                    AiInsightsCard(
                      insights: dashboard.aiInsights,
                    ),

                    const SizedBox(height: 24),

                    // ── Recent Tickets Table ──
                    RecentTicketsTable(
                      tickets: dashboard.recentTickets,
                    ),

                    const SizedBox(height: 24),

                    // ── Recent Users Table ──
                    RecentUsersTable(
                      users: dashboard.recentUsers,
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

const List<String> _statTitles = [
  "Total Users",
  "Total Tickets",
  "Open Tickets",
  "Resolved Tickets",
];

const List<IconData> _statIcons = [
  Icons.people_alt_rounded,
  Icons.confirmation_number_rounded,
  Icons.pending_actions_rounded,
  Icons.check_circle_rounded,
];

const List<Color> _statColors = [
  AppColors.info,
  AppColors.purple,
  AppColors.warning,
  AppColors.success,
];

List<String> _statValues(DashboardModel dashboard) {
  return [
    dashboard.stats.users.toString(),
    dashboard.stats.totalTickets.toString(),
    dashboard.stats.open.toString(),
    dashboard.stats.resolved.toString(),
  ];
}


