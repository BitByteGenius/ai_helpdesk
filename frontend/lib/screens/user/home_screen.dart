import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/user/widget/dashboard_header.dart';
import 'package:frontend/screens/user/widget/dashboard_stats.dart';
import 'package:frontend/screens/user/widget/quick_actions.dart';
import 'package:frontend/screens/user/widget/recent_ticket_card.dart';
import 'package:get/get.dart';

class UserDashboard extends GetView<TicketController> {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 700;

    return UserLayout(
      title: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 30),
            const DashboardStats(),
            const SizedBox(height: 30),
            const QuickActions(),
            const SizedBox(height: 30),
            const Text(
              "Recent Tickets",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.tickets.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "No tickets found",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop
                      ? 3
                      : isTablet
                          ? 2
                          : 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.0,
                ),
                itemCount: controller.tickets.length,
                itemBuilder: (_, index) {
                  return RecentTicketCard(
                    ticket: controller.tickets[index],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
