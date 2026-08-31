import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: context.surfaceSubtle,
              border: Border(bottom: BorderSide(color: context.border)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: context.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  "Conversation Stream",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: context.textPrimary,
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

          // ── Message Stream ──
          Container(
            height: 400,
            color: context.cardBg,
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
                        size: 40,
                        color: context.textMuted,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No messages yet",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Type a reply to start the conversation.",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isAdminReply = message.user.id != widget.ticket.createdBy.id;

                    return _buildMessageBubble(context, message, isAdminReply);
                  },
                ),
              );
            }),
          ),

          // ── Inline Loading Bar ──
          Obx(() {
            if (chatController.isUpdating.value) {
              return LinearProgressIndicator(minHeight: 2, color: context.primaryColor);
            }
            return const SizedBox(height: 2);
          }),

          // ── Chat Input Bar ──
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.surfaceSubtle,
              border: Border(top: BorderSide(color: context.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: context.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: textEditingController,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 16),
                  onPressed: _handleSend,
                  style: IconButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: Colors.white,
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
    final timeStr = "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}";

    final bubbleColor = isAdminReply ? context.primaryColor : (context.isDark ? const Color(0xFF334155) : AppColors.surfaceSubtle);
    final textColor = isAdminReply ? Colors.white : context.textPrimary;
    final senderColor = isAdminReply ? Colors.white.withValues(alpha: 0.85) : context.primaryColor;

    return Align(
      alignment: isAdminReply ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: isAdminReply ? const Radius.circular(14) : Radius.zero,
            bottomRight: isAdminReply ? Radius.zero : const Radius.circular(14),
          ),
          border: isAdminReply ? null : Border.all(color: context.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isAdminReply ? "${message.user.name} (Support)" : message.user.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: senderColor,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.message,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeStr,
                style: TextStyle(
                  fontSize: 10,
                  color: isAdminReply ? Colors.white.withValues(alpha: 0.6) : context.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
