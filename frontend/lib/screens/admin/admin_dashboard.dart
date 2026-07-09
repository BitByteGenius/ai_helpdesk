import 'package:flutter/material.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/models/darshboard_model.dart';
import 'package:frontend/screens/admin/widget/stat_card.dart';
import 'package:get/get.dart';


class AdminDashboard extends GetView<DashboardController> {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Admin Dashboard',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          final content = Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.hasError.value) {
              return Center(
                child: Text(controller.errorMessage.value),
              );
            }

            final dashboard = controller.dashboard.value;

            if (dashboard == null) {
              return const Center(
                child: Text("No Data"),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderBlock(
                      title: "Overview",
                      subtitle:
                          ".",
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth = constraints.maxWidth;
                        final crossAxisCount = availableWidth >= 1200
                            ? 4
                            : availableWidth >= 700
                                ? 2
                                : 1;
                        final childAspectRatio = availableWidth >= 700
                            ? 1.55
                            : 1.75;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 900;
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _PlaceholderCard(
                                  title: "Ticket Status Chart",
                                  height: 320,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _PlaceholderCard(
                                  title: "Priority Chart",
                                  height: 320,
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: const [
                            _PlaceholderCard(
                              title: "Ticket Status Chart",
                              height: 300,
                            ),
                            SizedBox(height: 16),
                            _PlaceholderCard(
                              title: "Priority Chart",
                              height: 300,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const _PlaceholderCard(
                      title: "Recent Tickets",
                      height: 340,
                    ),
                    const SizedBox(height: 16),
                    const _PlaceholderCard(
                      title: "Recent Users",
                      height: 340,
                    ),
                    const SizedBox(height: 16),
                    const _PlaceholderCard(
                      title: "AI Insights",
                      height: 220,
                    ),
                  ],
                ),
              ),
            );
          });
          return content;
        },
      ),
    );
  }
}

const List<String> _statTitles = [
  "Users",
  "Tickets",
  "Open",
  "Resolved",
];

const List<IconData> _statIcons = [
  Icons.people,
  Icons.confirmation_number,
  Icons.pending_actions,
  Icons.check_circle,
];

const List<Color> _statColors = [
  Colors.blue,
  Colors.deepPurple,
  Colors.orange,
  Colors.green,
];

List<String> _statValues(DashboardModel dashboard) {
  return [
    dashboard.users.total.toString(),
    dashboard.tickets.total.toString(),
    dashboard.status.open.toString(),
    dashboard.status.resolved.toString(),
  ];
}

class _HeaderBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderBlock({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String title;
  final double height;

  const _PlaceholderCard({
    required this.title,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
