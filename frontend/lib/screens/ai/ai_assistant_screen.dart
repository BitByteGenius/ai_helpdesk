import 'package:flutter/material.dart';
import 'package:frontend/screens/ai/widget/ai_input_bar.dart';
import 'package:frontend/screens/ai/widget/ai_message_bubble.dart';
import 'package:frontend/screens/ai/widget/ai_solution_card.dart';
import 'package:frontend/screens/ai/widget/ai_ticket_preview_card.dart';
import 'package:frontend/screens/ai/widget/ai_typing_indicator.dart';
import 'package:get/get.dart';

import '../../../controllers/ai_chat_controller.dart';


class AICopilotScreen extends GetView<AIChatController> {
  const AICopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🤖 AI Copilot"),
        centerTitle: true,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 900 : double.infinity,
          ),
          child: Column(
            children: [

              Expanded(
                child: Obx(() {
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [

                      if (controller.messages.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: const [

                                Icon(
                                  Icons.smart_toy,
                                  size: 70,
                                  color: Colors.blue,
                                ),

                                SizedBox(height: 20),

                                Text(
                                  "AI Helpdesk Copilot",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 12),

                                Text(
                                  "Describe your issue in natural language.\n\nI'll try to solve it before creating a support ticket.",
                                  textAlign:
                                      TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                      ...controller.messages
                          .map(
                            (m) =>
                                AIMessageBubble(
                              message: m,
                            ),
                          ),

                      if (controller.lastResponse.value !=
                          null)
                        AISolutionCard(
                          response:
                              controller.lastResponse.value!,
                        ),

                      const AITicketPreviewCard(),

                      if (controller.isTyping.value)
                        const AITypingIndicator(),

                      const SizedBox(height: 100),
                    ],
                  );
                }),
              ),

              const Divider(height: 1),

              const AIInputBar(),
            ],
          ),
        ),
      ),
    );
  }
}