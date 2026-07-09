import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/core/routes/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 900
        ? 4
        : width > 600
            ? 2
            : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.2,
          children: const [

            _ActionCard(
              title: "Create Ticket",
              subtitle: "Raise a new support request",
              icon: Icons.add_circle_outline,
              color: Colors.blue,
              route: AppRoutes.createTicket,
            ),

            _ActionCard(
              title: "My Tickets",
              subtitle: "View all submitted tickets",
              icon: Icons.confirmation_number_outlined,
              color: Colors.orange,
              route: AppRoutes.myTickets,
            ),

            _ActionCard(
              title: "AI Assistant",
              subtitle: "Get AI help instantly",
              icon: Icons.smart_toy_outlined,
              color: Colors.deepPurple,
              route: AppRoutes.aiAssistant,
            ),

            _ActionCard(
              title: "Profile",
              subtitle: "Manage your account",
              icon: Icons.person_outline,
              color: Colors.green,
              route: AppRoutes.profile,
            ),
          ],
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.toNamed(route);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}