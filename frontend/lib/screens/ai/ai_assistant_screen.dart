import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 850;

    final chatInterface = Column(
      children: [
        // ── Chat Header ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.card,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
              ),
            ),
          ),
          child: Row(
            children: [
              if (!isDesktop) ...[
                IconButton(
                  icon: const Icon(Icons.history_rounded, size: 20),
                  tooltip: "Chat History",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F172A),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: const AIConversationSidebar(isDrawer: true),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],

              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.currentConversationTitle.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        "AI Copilot Assistant",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Obx(() {
                if (controller.messages.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                    tooltip: "Clear Chat",
                    onPressed: () => controller.clearActiveConversation(),
                  );
                }
                return const SizedBox.shrink();
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                    color: Colors.black.withValues(alpha: 0.35),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text("Analyzing chat context...", style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
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

    return UserLayout(
      title: 'AI Copilot',
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          if (isDesktop) const AIConversationSidebar(isDrawer: false),
          Expanded(child: chatInterface),
        ],
      ),
    );
  }


  Widget _buildWelcomeScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 620),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to AI Support Copilot",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.4,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ask anything! I can answer questions, diagnose issues, or guide you through solutions. If needed, I can automatically generate a support ticket with your chat transcript.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suggested Prompts",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.suggestedPrompts
                    .map((prompt) => InkWell(
                          onTap: () => controller.sendMessage(customText: prompt),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    prompt,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primarySubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                "Need additional help?",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "I can generate a complete support ticket directly from our conversation. You can review and edit it before submission.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
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
                  icon: const Icon(Icons.add_box_outlined, size: 16),
                  label: const Text("Create Ticket", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () {
                    controller.canCreateTicket.value = false;
                  },
                  child: const Text("Continue Chat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.inputController,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: "Describe your issue or ask a question...",
                isDense: true,
                filled: true,
                fillColor: AppColors.surfaceSubtle,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) {
                controller.sendMessage();
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            icon: const Icon(Icons.send_rounded, size: 18),
            onPressed: () => controller.sendMessage(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}