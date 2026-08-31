import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/screens/ai/widget/ai_ticket_preview_dialog.dart';
import 'package:get/get.dart';

class AIEscalationCard extends GetView<AIChatController> {
  const AIEscalationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.canCreateTicket.value) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: context.primarySubtle,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  color: context.primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  "Need more help?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "It looks like this issue hasn't been completely resolved. I can create a support ticket using this conversation so our support team has the complete context.",
              style: TextStyle(
                height: 1.4,
                fontSize: 13,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: controller.isGeneratingTicket.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.confirmation_number_outlined, size: 16),
                    label: Text(
                      controller.isGeneratingTicket.value ? "Generating..." : "Create Ticket",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: controller.isGeneratingTicket.value
                        ? null
                        : () async {
                            final draft = await controller.generateTicketDraft();
                            if (draft == null) return;
                            Get.dialog(
                              AITicketPreviewDialog(
                                draft: draft,
                                chatMessages: controller.messages.toList(),
                              ),
                            );
                          },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.border),
                  ),
                  onPressed: () {
                    controller.canCreateTicket.value = false;
                  },
                  child: const Text("Continue Chat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}