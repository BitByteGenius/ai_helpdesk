import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ai_model/ai_conversation_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AIConversationSidebar extends GetView<AIChatController> {
  final bool isDrawer;

  const AIConversationSidebar({
    super.key,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: 280,
      decoration: BoxDecoration(
        color: context.cardBg,
        border: Border(right: BorderSide(color: context.border)),
      ),
      child: Column(
        children: [
          // ── Header & New Chat ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text("New Chat", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onPressed: () {
                      controller.startNewChat();
                    },
                  ),
                  const SizedBox(height: 12),
                  // ── Search conversations ──
                  TextField(
                    onChanged: (val) {
                      controller.searchConversationsQuery.value = val;
                    },
                    style: TextStyle(color: context.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search chats...",
                      hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: context.textSecondary),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: context.borderLight),

          // ── Conversation Lists ──
          Expanded(
            child: Obx(() {
              if (controller.isLoadingConversations.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filtered = controller.filteredConversations;
              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No conversations found",
                      style: TextStyle(
                        color: context.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }

              final pinned = filtered.where((c) => c.isPinned).toList();
              final recent = filtered.where((c) => !c.isPinned).toList();

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (pinned.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "PINNED",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.5,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    ...pinned.map((c) => _buildChatItem(context, c)),
                    const SizedBox(height: 12),
                  ],
                  if (recent.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "RECENT CHATS",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.5,
                          color: context.textMuted,
                        ),
                      ),
                    ),
                    ...recent.map((c) => _buildChatItem(context, c)),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );

    if (isDrawer) {
      return Drawer(
        child: content,
      );
    }
    return content;
  }

  Widget _buildChatItem(BuildContext context, AIConversationModel chat) {
    return Obx(() {
      final isActive = controller.currentConversationId.value == chat.id;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        child: Material(
          color: isActive ? context.primarySubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              controller.loadConversation(chat.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    chat.isPinned ? Icons.push_pin_rounded : Icons.chat_bubble_outline_rounded,
                    size: 16,
                    color: isActive ? context.primaryColor : context.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? context.primaryColor : context.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(chat.updatedAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: context.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive) _buildItemActions(context, chat),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildItemActions(BuildContext context, AIConversationModel chat) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(chat.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 14),
          color: context.primaryColor,
          tooltip: chat.isPinned ? "Unpin" : "Pin",
          onPressed: () {
            controller.togglePinConversation(chat.id, !chat.isPinned);
          },
        ),
        const SizedBox(width: 6),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.edit_outlined, size: 14, color: context.textSecondary),
          tooltip: "Rename",
          onPressed: () {
            _showRenameDialog(context, chat);
          },
        ),
        const SizedBox(width: 6),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete_outline_rounded, size: 14),
          color: AppColors.error,
          tooltip: "Delete",
          onPressed: () {
            _showDeleteDialog(context, chat);
          },
        ),
      ],
    );
  }

  void _showRenameDialog(BuildContext context, AIConversationModel chat) {
    final editController = TextEditingController(text: chat.title);
    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Rename Chat", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: context.textPrimary)),
        content: TextField(
          controller: editController,
          style: TextStyle(color: context.textPrimary, fontSize: 13),
          decoration: const InputDecoration(
            hintText: "Enter conversation title",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              controller.renameConversation(chat.id, editController.text);
              Get.back();
            },
            child: const Text("Rename"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AIConversationModel chat) {
    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Chat?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: context.textPrimary)),
        content: Text("Are you sure you want to delete '${chat.title}'? This action cannot be undone.", style: TextStyle(fontSize: 13, color: context.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              controller.deleteConversation(chat.id);
              Get.back();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
