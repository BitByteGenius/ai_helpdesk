import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
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
    final theme = Theme.of(context);
    final sidebarColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainer
        : theme.colorScheme.surfaceContainerLowest;

    final content = Container(
      width: 280,
      color: sidebarColor,
      child: Column(
        children: [
          // ── Header & New Chat ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("New Chat"),
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
                    decoration: InputDecoration(
                      hintText: "Search chats...",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // ── Conversation Lists ──
          Expanded(
            child: Obx(() {
              if (controller.isLoadingConversations.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filtered = controller.filteredConversations;
              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    "No conversations found",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
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
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    ...pinned.map((c) => _buildChatItem(context, c)),
                    const SizedBox(height: 16),
                  ],
                  if (recent.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "RECENT CHATS",
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    final isActive = controller.currentConversationId.value == chat.id;

    final tileColor = isActive
        ? theme.colorScheme.primary.withOpacity(0.08)
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Icon(
            chat.isPinned ? Icons.push_pin : Icons.chat_bubble_outline,
            size: 18,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
          ),
          title: Text(
            chat.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM dd, hh:mm a').format(chat.updatedAt),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
          trailing: isActive ? _buildItemActions(context, chat) : null,
          onTap: () {
            controller.loadConversation(chat.id);
          },
        ),
      ),
    );
  }

  Widget _buildItemActions(BuildContext context, AIConversationModel chat) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined, size: 16),
          color: theme.colorScheme.primary,
          tooltip: chat.isPinned ? "Unpin" : "Pin",
          onPressed: () {
            controller.togglePinConversation(chat.id, !chat.isPinned);
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 16),
          tooltip: "Rename",
          onPressed: () {
            _showRenameDialog(context, chat);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 16),
          color: theme.colorScheme.error,
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
        title: const Text("Rename Chat"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: "Enter conversation title",
            border: OutlineInputBorder(),
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
        title: const Text("Delete Chat?"),
        content: Text("Are you sure you want to delete '${chat.title}'? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
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
