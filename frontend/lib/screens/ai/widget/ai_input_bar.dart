import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class AIInputBar extends GetView<AIChatController> {
  const AIInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.inputController,
              style: TextStyle(fontSize: 13, color: context.textPrimary),
              decoration: InputDecoration(
                hintText: "Describe your issue or ask a question...",
                hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
                isDense: true,
                filled: true,
                fillColor: context.surfaceSubtle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) {
                controller.sendMessage();
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            icon: const Icon(Icons.send_rounded, size: 18),
            onPressed: controller.sendMessage,
            style: IconButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}