import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/user/widget/recent_ticket_card.dart';
import 'package:get/get.dart';

class MyTicketsScreen extends GetView<TicketController> {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'My Tickets',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh',
          onPressed: controller.refreshTickets,
        ),
        const SizedBox(width: 8),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1100;
          final isTablet = constraints.maxWidth >= 700;
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header & Action ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Support Tickets",
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
                          "Search and track all tickets submitted under your account.",
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.createTicket),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text("New Ticket"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Search & Controls ──
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.border),
                  ),
                  child: TextField(
                    onChanged: controller.searchTickets,
                    decoration: const InputDecoration(
                      hintText: "Search tickets by title, description or category...",
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Ticket List / Grid ──
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.hasError.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                            const SizedBox(height: 12),
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(color: context.textPrimary, fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: controller.refreshTickets,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text("Try Again"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.tickets.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: context.primarySubtle,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.confirmation_number_outlined,
                                color: context.primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No tickets found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Try adjusting your search query or submit a new ticket.",
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 3 : isTablet ? 2 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 1.55 : 1.7,
                      ),
                      itemCount: controller.tickets.length,
                      itemBuilder: (_, index) {
                        return RecentTicketCard(
                          ticket: controller.tickets[index],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
