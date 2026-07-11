import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:get/get.dart';


class AITicketPreviewCard
    extends GetView<AIChatController> {
  const AITicketPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      final ai = controller.lastResponse.value;
      final ticketController = Get.find<TicketController>();

      if (ai == null || !ai.createTicket) {
        return const SizedBox();
      }

      return Card(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "Ticket Preview",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Category : ${ai.category}",
              ),

              Text(
                "Priority : ${ai.priority}",
              ),

              const SizedBox(height: 10),

              Text(
                ai.aiSummary,
              ),

              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: () async {
                  
                await ticketController.createTicket();
                  
                },
                icon:
                    const Icon(Icons.add),
                label:
                    const Text("Create Ticket"),
              ),
            ],
          ),
        ),
      );
    });
  }
}