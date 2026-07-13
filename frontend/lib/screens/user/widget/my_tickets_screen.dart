import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/user/widget/recent_ticket_card.dart';
import 'package:get/get.dart';



class MyTicketsScreen extends GetView<TicketController> {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'My Tickets',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "My Tickets",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [

                        Expanded(
                          child: TextField(
                            onChanged:
                                controller.searchTickets,
                            decoration:
                                InputDecoration(
                              hintText:
                                  "Search tickets...",
                              prefixIcon:
                                  const Icon(Icons.search),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        ElevatedButton.icon(
                          onPressed:
                              controller.refreshTickets,
                          icon:
                              const Icon(Icons.refresh),
                          label:
                              const Text("Refresh"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Expanded(
                      child: Obx(() {

                        if (controller.isLoading.value) {
                          return const Center(
                            child:
                                CircularProgressIndicator(),
                          );
                        }

                        if (controller.hasError.value) {
                          return Center(
                            child: Text(
                              controller.errorMessage
                                  .value,
                            ),
                          );
                        }

                        if (controller.tickets.isEmpty) {
                          return const Center(
                            child: Text(
                              "No tickets found",
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount:
                              controller.tickets.length,
                          separatorBuilder:
                              (_, _) =>
                                  const SizedBox(height: 15),
                          itemBuilder: (_, index) {

                            return RecentTicketCard(
                              ticket:
                                  controller.tickets[index],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
      )
    );
  }
}
