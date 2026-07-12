import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
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
              margin: const EdgeInsets.only(right: 12, top: 4),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],

          // ── Chat Bubble ──
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                  ),
                  child: isUser
                      ? Text(
                          message.message,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : MarkdownBody(
                          data: message.message,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                            code: TextStyle(
                              backgroundColor: theme.colorScheme.surfaceContainerLowest,
                              color: theme.colorScheme.secondary,
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                            codeblockPadding: const EdgeInsets.all(12),
                            codeblockDecoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                              ),
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
                      Icon(Icons.error_outline, size: 14, color: theme.colorScheme.error),
                      const SizedBox(width: 4),
                      Text(
                        "Failed to send",
                        style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => controller.retryFailedMessage(message),
                        child: Text(
                          "Retry",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
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
                    padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.copy, size: 16),
                          tooltip: "Copy message",
                          onPressed: () => controller.copyToClipboard(message.message),
                        ),
                        if (isLast) ...[
                          const SizedBox(width: 12),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.refresh, size: 16),
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
                    padding: const EdgeInsets.only(top: 6.0, right: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit, size: 16),
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
              margin: const EdgeInsets.only(left: 12, top: 4),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Icon(
                  Icons.person_outline,
                  size: 20,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
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
        title: const Text("Edit Message"),
        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Edit your prompt...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
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