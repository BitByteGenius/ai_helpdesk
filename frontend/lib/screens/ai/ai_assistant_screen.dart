import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/ai/widget/ai_conversation_sidebar.dart';
import 'package:frontend/screens/ai/widget/ai_message_bubble.dart';
import 'package:frontend/screens/ai/widget/ai_ticket_preview_dialog.dart';
import 'package:frontend/screens/ai/widget/ai_typing_indicator.dart';
import 'package:get/get.dart';

class AICopilotScreen extends GetView<AIChatController> {
  const AICopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 850;

    final chatInterface = Column(
      children: [
        // ── Chat Header ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withOpacity(0.4),
              ),
            ),
          ),
          child: Row(
            children: [
              if (!isDesktop) ...[
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(ctx).openDrawer();
                    },
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() {
                  return Text(
                    controller.currentConversationTitle.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
              Obx(() {
                if (controller.messages.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: "Clear Chat Messages",
                    onPressed: () => controller.clearActiveConversation(),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),

        // ── Main Chat Area ──
        Expanded(
          child: Stack(
            children: [
              Obx(() {
                if (controller.isLoadingMessages.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messages.isEmpty) {
                  return _buildWelcomeScreen(context);
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final msg = controller.messages[index];
                    final isLast = index == controller.messages.length - 1;
                    return AIMessageBubble(
                      message: msg,
                      isLast: isLast,
                    );
                  },
                );
              }),

              // Loading Draft modal overlay
              Obx(() {
                if (controller.isGeneratingTicket.value) {
                  return Container(
                    color: Colors.black45,
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text("Analyzing chat context..."),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),

        // ── Escalation UI & Typing indicator ──
        Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isTyping.value) const AITypingIndicator(),
              if (controller.canCreateTicket.value && controller.messages.isNotEmpty)
                _buildEscalationPanel(context),
            ],
          );
        }),

        // ── Input Bar ──
        _buildInputBar(context),
      ],
    );

    return Scaffold(
      drawer: !isDesktop ? const AIConversationSidebar(isDrawer: true) : null,
      body: UserLayout(
        title: '🤖 AI Copilot',
        child: Row(
          children: [
            if (isDesktop) ...[
              const AIConversationSidebar(isDrawer: false),
              const VerticalDivider(width: 1),
            ],
            Expanded(child: chatInterface),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 24),
              Text(
                "Welcome to AI Support Assistant",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Ask anything! I will search for answers or help troubleshoot your IT issues directly. If I can't resolve it, I'll generate a support ticket automatically.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suggested Prompts",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.suggestedPrompts
                    .map((prompt) => ActionChip(
                          avatar: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: theme.colorScheme.primary),
                          label: Text(prompt),
                          onPressed: () {
                            controller.sendMessage(customText: prompt);
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEscalationPanel(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Need additional help?",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "I can generate a complete support ticket directly from our conversation history. You can edit it before submitting.",
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    controller.isGeneratingTicket.value = true;
                    final draft = await controller.generateTicketDraft();
                    controller.isGeneratingTicket.value = false;
                    if (draft != null) {
                      Get.dialog(
                        AITicketPreviewDialog(
                          draft: draft,
                          chatMessages: controller.messages,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_box_outlined, size: 18),
                  label: const Text("Create Ticket"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.canCreateTicket.value = false;
                  },
                  child: const Text("Continue Chat"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.inputController,
                decoration: InputDecoration(
                  hintText: "Describe your issue or ask a question...",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onSubmitted: (_) {
                  controller.sendMessage();
                },
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () => controller.sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}