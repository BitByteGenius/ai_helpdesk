import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/tickets/ticket_details_screen.dart';
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
      child: Stack(
        children: [
          Obx(() {
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

            return RefreshIndicator(
              onRefresh: controller.refreshTickets,
              child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1000;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tickets",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Search
                    const TicketSearch(),

                    const SizedBox(height: 20),

                    /// Filters
                    const TicketFilter(),

                    const SizedBox(height: 30),

                    if (controller.tickets.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            "No Tickets Found",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    else if (isDesktop)
                      TicketTable(
                        tickets: controller.tickets,
                        onView: (ticket) {
                          Get.to(
                            () => TicketDetailsScreen(
                              ticketId: ticket.id,
                            ),
                          );
                        },
                        onDelete: (ticket) {
                          Get.defaultDialog(
                            title: "Delete Ticket",
                            middleText:
                                "Are you sure you want to delete this ticket?",
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.back();
                              controller.deleteTicket(ticket.id);
                            },
                          );
                        },
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: controller.tickets.length,
                        itemBuilder: (_, index) {
                          final ticket =
                              controller.tickets[index];

                          return TicketCard(
                            ticket: ticket,
                            isAdmin: true,
                            onTap: () {
                              Get.to(
                                () => TicketDetailsScreen(
                                  ticketId: ticket.id,
                                ),
                              );
                            },
                            onDelete: () {
                              Get.defaultDialog(
                                title: "Delete Ticket",
                                middleText:
                                    "Are you sure?",
                                textCancel: "Cancel",
                                textConfirm: "Delete",
                                confirmTextColor:
                                    Colors.white,
                                onConfirm: () {
                                  Get.back();
                                  controller
                                      .deleteTicket(
                                          ticket.id);
                                },
                              );
                            },
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
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                // TODO: Open Create Ticket Screen
              },
              icon: const Icon(Icons.add),
              label: const Text("New Ticket"),
            ),
          ),
        ],
      ),
    );
  }
}
