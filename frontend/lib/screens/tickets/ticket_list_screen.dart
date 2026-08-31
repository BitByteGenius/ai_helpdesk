import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/tickets/admin_d/admin_ticket_details_screen.dart';
import 'package:frontend/screens/tickets/widgets/ticket_card.dart';
import 'package:frontend/screens/tickets/widgets/ticket_filter.dart';
import 'package:frontend/screens/tickets/widgets/ticket_search.dart';
import 'package:frontend/screens/tickets/widgets/ticket_table.dart';
import 'package:get/get.dart';

import '../../../controllers/ticket_controller.dart';

class TicketListScreen extends GetView<TicketController> {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Ticket Management',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh Tickets',
          onPressed: controller.refreshTickets,
        ),
        const SizedBox(width: 8),
      ],
      child: Obx(() {
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
                  const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
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
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTickets,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1000;
              final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
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
                              "All Tickets",
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
                              "View, triage, assign and manage all customer support tickets.",
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Search & Filters Block ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TicketSearch(),
                          SizedBox(height: 14),
                          TicketFilter(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Tickets Content ──
                    if (controller.tickets.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.border),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: context.primarySubtle,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.confirmation_number_outlined,
                                  size: 26,
                                  color: context.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "No Tickets Found",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: context.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Try modifying your search or clear the active filter parameters.",
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (isDesktop)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TicketTable(
                          tickets: controller.tickets,
                          onView: (ticket) {
                            Get.to(
                              () => AdminTicketDetailsScreen(
                                ticketId: ticket.id,
                              ),
                            );
                          },
                          onDelete: (ticket) => _showDeleteDialog(context, ticket.id),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.tickets.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final ticket = controller.tickets[index];
                          return TicketCard(
                            ticket: ticket,
                            isAdmin: true,
                            onTap: () {
                              Get.to(
                                () => AdminTicketDetailsScreen(
                                  ticketId: ticket.id,
                                ),
                              );
                            },
                            onDelete: () => _showDeleteDialog(context, ticket.id),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, String ticketId) {
    Get.defaultDialog(
      title: "Delete Ticket",
      titleStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: context.textPrimary),
      middleText: "Are you sure you want to permanently delete this ticket?",
      middleTextStyle: TextStyle(color: context.textSecondary, fontSize: 13),
      textCancel: "Cancel",
      textConfirm: "Delete",
      cancelTextColor: context.textPrimary,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      radius: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      titlePadding: const EdgeInsets.only(top: 24),
      onConfirm: () {
        Get.back();
        controller.deleteTicket(ticketId);
      },
    );
  }
}