import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/chat_controller.dart';
import '../../../models/comment_model.dart';
import '../../../models/ticket_model.dart';

class ChatSectionWidget extends StatefulWidget {
  final TicketModel ticket;

  const ChatSectionWidget({
    super.key,
    required this.ticket,
  });

  @override
  State<ChatSectionWidget> createState() => _ChatSectionWidgetState();
}

class _ChatSectionWidgetState extends State<ChatSectionWidget> {
  late final ChatController chatController;
  late final AuthController authController;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController = Get.find<ChatController>();
    authController = Get.find<AuthController>();

    // Load messages on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.loadMessages(widget.ticket.id);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = textEditingController.text.trim();
    if (text.isNotEmpty) {
      chatController.sendMessage(widget.ticket.id, text);
      textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Conversation Stream",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Obx(() {
                  if (chatController.isLoading.value) {
                    return const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),

          // Message Stream
          Container(
            height: 400,
            color: theme.colorScheme.surfaceContainerLowest,
            child: Obx(() {
              final messages = chatController.messagesList;

              if (chatController.isLoading.value && messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No messages yet",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Type a reply to start the conversation.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Scrollbar(
                controller: chatController.scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: chatController.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    // Align right if it is an Admin reply: meaning not created by the ticket creator.
                    final isAdminReply = message.user.id != widget.ticket.createdBy.id;

                    return _buildMessageBubble(context, message, isAdminReply);
                  },
                ),
              );
            }),
          ),

          // Inline Loading Bar
          Obx(() {
            if (chatController.isUpdating.value) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            return const SizedBox(height: 2);
          }),

          // Chat Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: textEditingController,
                      style: theme.textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send, size: 18),
                  onPressed: _handleSend,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, CommentModel message, bool isAdminReply) {
    final theme = Theme.of(context);
    final timeStr = "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}";

    // Colors: Admin (Primary Brand Color Tint), Client (Grey/Light Tint)
    final bubbleColor = isAdminReply
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .8);
    final textColor = isAdminReply
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;
    final senderColor = isAdminReply
        ? theme.colorScheme.onPrimary.withValues(alpha: .8)
        : theme.colorScheme.primary.withValues(alpha: .9);

    return Align(
      alignment: isAdminReply ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isAdminReply ? const Radius.circular(16) : Radius.zero,
            bottomRight: isAdminReply ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sender Name
            Text(
              isAdminReply ? "${message.user.name} (Admin)" : message.user.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: senderColor,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),

            // Message text
            Text(
              message.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),

            // Timestamp in bottom-right corner of the bubble
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeStr,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: isAdminReply
                      ? theme.colorScheme.onPrimary.withValues(alpha: .6)
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
