import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:get/get.dart';

class DashboardStats extends GetView<TicketController> {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 1100
        ? 4
        : width > 700
            ? 2
            : 1;

    return Obx(() {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: width > 700 ? 2.65 : 2.4,
        children: [
          _StatCard(
            title: "My Tickets",
            value: controller.totalTicketsCount.toString(),
            icon: Icons.confirmation_number,
            color: Colors.blue,
          ),
          _StatCard(
            title: "Open",
            value: controller.openTicketsCount.toString(),
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
          _StatCard(
            title: "In Progress",
            value: controller.inProgressTicketsCount.toString(),
            icon: Icons.sync,
            color: Colors.deepPurple,
          ),
          _StatCard(
            title: "Resolved",
            value: controller.resolvedTicketsCount.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ],
      );
    });
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
