import 'package:flutter/material.dart';
import 'package:frontend/screens/ai/widget/ai_input_bar.dart';
import 'package:frontend/screens/ai/widget/ai_message_bubble.dart';
import 'package:frontend/screens/ai/widget/ai_solution_card.dart';
import 'package:frontend/screens/ai/widget/ai_ticket_preview_card.dart';
import 'package:frontend/screens/ai/widget/ai_typing_indicator.dart';
import 'package:get/get.dart';

import '../../../controllers/ai_chat_controller.dart';
import '../../layouts/user_layout.dart';

class AICopilotScreen extends GetView<AIChatController> {
  const AICopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return UserLayout(
      title: '🤖 AI Copilot',
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32.0 : 16.0,
                      vertical: 20.0,
                    ),
                    children: [
                      if (controller.messages.isEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.smart_toy_outlined,
                                    size: 56,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "AI Helpdesk Copilot",
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Describe your issue in natural language.\n\nI'll try to solve it before creating a support ticket.",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ...controller.messages.map(
                        (m) => AIMessageBubble(message: m),
                      ),
                      if (controller.lastResponse.value != null)
                        AISolutionCard(response: controller.lastResponse.value!),
                      const AITicketPreviewCard(),
                      if (controller.isTyping.value)
                        const AITypingIndicator(),
                      const SizedBox(height: 120),
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