import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ai_model/chat_message_model.dart';
import 'package:get/get.dart';

class AIMessageBubble extends GetView<AIChatController> {
  final ChatMessageModel message;
  final bool isLast;

  const AIMessageBubble({
    super.key,
    required this.message,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == "user";
    final hasFailed = controller.failedMessageIds.contains(message.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Assistant Avatar ──
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 12, top: 2),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],

          // ── Chat Bubble ──
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser ? null : Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isUser
                      ? Text(
                          message.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: message.message,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                            code: const TextStyle(
                              backgroundColor: AppColors.surfaceSubtle,
                              color: AppColors.primary,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                            codeblockPadding: const EdgeInsets.all(12),
                            codeblockDecoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                          ),
                        ),
                ),

                // ── Failed message retry button ──
                if (hasFailed) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      const Text(
                        "Failed to send",
                        style: TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => controller.retryFailedMessage(message),
                        child: const Text(
                          "Retry",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // ── Assistant Message Action Icons ──
                if (!isUser && !message.message.startsWith("⚠️ Error")) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.copy_rounded, size: 14, color: AppColors.textMuted),
                          tooltip: "Copy message",
                          onPressed: () => controller.copyToClipboard(message.message),
                        ),
                        if (isLast) ...[
                          const SizedBox(width: 12),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.refresh_rounded, size: 14, color: AppColors.textMuted),
                            tooltip: "Regenerate response",
                            onPressed: () => controller.regenerateResponse(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // ── User Message Action Icons ──
                if (isUser) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.textMuted),
                          tooltip: "Edit message",
                          onPressed: () => _showEditMessageDialog(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── User Avatar ──
          if (isUser) ...[
            Container(
              margin: const EdgeInsets.only(left: 12, top: 2),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditMessageDialog(BuildContext context) {
    final textController = TextEditingController(text: message.message);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Message", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Edit your prompt...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              final newText = textController.text.trim();
              if (newText.isNotEmpty && newText != message.message) {
                Get.back();
                controller.editUserMessage(message.id, newText);
              }
            },
            child: const Text("Save & Submit"),
          ),
        ],
      ),
    );
  }
}