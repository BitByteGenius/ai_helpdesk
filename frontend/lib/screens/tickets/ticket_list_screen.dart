import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return AdminLayout(
      title: 'Ticket Management',
      child: Stack(
        children: [
          Obx(() {
            // 1. Loading State (Centered with a professional touch)
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              );
            }

            // 2. Error State (Clean error card layout)
            if (controller.hasError.value) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Main Dynamic Grid/List View
            return RefreshIndicator(
              onRefresh: controller.refreshTickets,
              color: theme.primaryColor,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 1000;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Responsive Header Layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tickets",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Search and Filter controls housed inside a modern unified surface block
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const TicketSearch(),
                              const SizedBox(height: 12),
                              const TicketFilter(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Ticket Items Presentation logic
                        if (controller.tickets.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 80),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.confirmation_number_outlined,
                                    size: 64,
                                    color: theme.disabledColor.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No Tickets Found",
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.hintColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (isDesktop)
                          // Table wrapper container for professional enterprise UI
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
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
                          // Mobile Layout: Generates spacing between individual cards
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
                        // Bottom cushion space to prevent floating action button overlaps
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          
        ],
      ),
    );
  }

  // Extracted styled dialog helper matching modern design specifications
  void _showDeleteDialog(BuildContext context, String ticketId) {
    final theme = Theme.of(context);
    Get.defaultDialog(
      title: "Delete Ticket",
      titleStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to permanently delete this ticket?",
      middleTextStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      textCancel: "Cancel",
      textConfirm: "Delete",
      cancelTextColor: theme.colorScheme.primary,
      confirmTextColor: theme.colorScheme.onError,
      buttonColor: theme.colorScheme.error,
      radius: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      titlePadding: const EdgeInsets.only(top: 24),
      onConfirm: () {
        Get.back();
        controller.deleteTicket(ticketId);
      },
    );
  }
}