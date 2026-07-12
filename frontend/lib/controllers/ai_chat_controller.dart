import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/ai_model/chat_message_model.dart';
import 'package:frontend/models/ai_model/ai_conversation_model.dart';
import 'package:get/get.dart';
import '../servicies/ai_chat_service.dart';

class AIChatController extends GetxController {
  final AIChatService _service;

  AIChatController(this._service);

  // Conversation history list
  final conversations = <AIConversationModel>[].obs;
  final searchConversationsQuery = "".obs;

  // Selected conversation
  final currentConversationId = Rxn<String>();
  final currentConversationTitle = "New Chat".obs;

  // Messages for active conversation
  final messages = <ChatMessageModel>[].obs;
  final inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Loading / Typing States
  final isTyping = false.obs;
  final isLoadingConversations = false.obs;
  final isLoadingMessages = false.obs;
  final isGeneratingTicket = false.obs;

  // Actions states
  final canCreateTicket = false.obs;
  final failedMessageIds = <String>{}.obs;

  // Sidebar / Drawer navigation helper
  final isSidebarOpen = true.obs;

  final suggestedPrompts = [
    "Explain Flutter State Management",
    "Write a leave application",
    "My printer is offline",
    "Outlook crashes",
    "How do I reset my password?",
    "What is Docker?",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Get list of conversations for history
  Future<void> fetchConversations() async {
    try {
      isLoadingConversations.value = true;
      final list = await _service.getConversations();
      conversations.assignAll(list);
    } catch (e) {
      Get.snackbar(
        "History Error",
        "Failed to load chat history: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingConversations.value = false;
    }
  }

  /// Start a brand new chat session
  void startNewChat() {
    currentConversationId.value = null;
    currentConversationTitle.value = "New Chat";
    messages.clear();
    canCreateTicket.value = false;
    failedMessageIds.clear();
    Get.back(); // Close mobile drawer if open
  }

  /// Load details & messages of a selected conversation
  Future<void> loadConversation(String id) async {
    try {
      isLoadingMessages.value = true;
      failedMessageIds.clear();
      canCreateTicket.value = false;

      // Find details from list to instantly update title
      final details = conversations.firstWhereOrNull((c) => c.id == id);
      if (details != null) {
        currentConversationTitle.value = details.title;
        currentConversationId.value = details.id;
      }

      // Fetch latest messages from API
      // Since getConversationDetails endpoint returns details including messages, we call updateConversation or similar.
      // Wait, let's fetch detail via getConversations / load message list
      // final response = await _service._dio.get("ai/conversations/$id");
      // final fullConv = AIConversationModel.fromJson(response.data["data"]);

      // messages.assignAll(fullConv.messages);

      final fullConv = await _service.getConversation(id);

         messages.assignAll(fullConv.messages);

      // If the last message is from assistant, check if we can escalate
      if (messages.isNotEmpty && messages.last.role == "assistant") {
        // We allow ticket escalation on loaded support conversations
        canCreateTicket.value = true;
      }

      scrollToBottom();
      Get.back(); // Close mobile drawer if open
    } catch (e) {
      Get.snackbar(
        "Load Chat Failed",
        "Could not load conversation: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Send message
  Future<void> sendMessage({String? customText}) async {
    final text = (customText ?? inputController.text).trim();
    if (text.isEmpty) return;

    if (customText == null) {
      inputController.clear();
    }

    final localMsgId = UniqueKey().toString();

    // Add user message locally
    final userMsg = ChatMessageModel(
      id: localMsgId,
      role: "user",
      message: text,
      createdAt: DateTime.now(),
    );
    messages.add(userMsg);

    isTyping.value = true;
    canCreateTicket.value = false;
    scrollToBottom();

    try {
      final response = await _service.chat(
        message: text,
        conversationId: currentConversationId.value,
      );

      final reply = (response["reply"] ?? "").toString().trim();
      final ticketFlag = response["canCreateTicket"] ?? false;
      final newId = response["conversationId"]?.toString();
      final newTitle = response["title"]?.toString();

      // Check if conversation ID changed (e.g. first message initialized session)
      if (newId != null && currentConversationId.value != newId) {
        currentConversationId.value = newId;
        if (newTitle != null) {
          currentConversationTitle.value = newTitle;
        }
        await fetchConversations();
      } else if (newTitle != null &&
          currentConversationTitle.value != newTitle) {
        currentConversationTitle.value = newTitle;
        await fetchConversations();
      }

      // Add assistant response
      messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          role: "assistant",
          message: reply.isNotEmpty
              ? reply
              : "I’m sorry, I couldn’t generate a response right now. Please try again in a moment.",
          createdAt: DateTime.now(),
        ),
      );

      canCreateTicket.value = ticketFlag;
    } catch (e) {
      failedMessageIds.add(localMsgId);
      Get.snackbar(
        "Connection Error",
        "Unable to send message. You may be offline.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );

      messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          role: "assistant",
          message:
              "⚠️ Error sending message. Please verify your connection and try again.",
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      isTyping.value = false;
      scrollToBottom();
    }
  }

  /// Retry sending a failed message
  Future<void> retryFailedMessage(ChatMessageModel failedMessage) async {
    // Remove the error message from assistant if it was the last message
    if (messages.isNotEmpty &&
        messages.last.role == "assistant" &&
        messages.last.message.startsWith("⚠️ Error")) {
      messages.removeLast();
    }

    // Remove from failed set
    failedMessageIds.remove(failedMessage.id);

    // Resend
    await sendMessage(customText: failedMessage.message);
  }

  /// Regenerate the last AI reply
  Future<void> regenerateResponse() async {
    if (messages.isEmpty) return;

    // Remove last assistant message
    if (messages.last.role == "assistant") {
      messages.removeLast();
    }

    // Find the last user message
    // final lastUserMsg = messages.lastWhereOrNull((m) => m.role == "user");
    // if (lastUserMsg == null) return;

    ChatMessageModel? lastUserMsg;

for (final message in messages.reversed) {
  if (message.role == "user") {
    lastUserMsg = message;
    break;
  }
}

if (lastUserMsg == null) return;

    isTyping.value = true;
    canCreateTicket.value = false;
    scrollToBottom();

    try {
      final response = await _service.chat(
        message: lastUserMsg.message,
        conversationId: currentConversationId.value,
      );

      messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          role: "assistant",
          message: response["reply"] ?? "",
          createdAt: DateTime.now(),
        ),
      );

      canCreateTicket.value = response["canCreateTicket"] ?? false;
    } catch (e) {
      Get.snackbar(
        "Regeneration Failed",
        "Could not regenerate response: $e",
        snackPosition: SnackPosition.BOTTOM,
      );

      messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          role: "assistant",
          message: "⚠️ Regeneration failed. Please try again later.",
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  /// Generate draft ticket from conversation
  Future<Map<String, dynamic>?> generateTicketDraft() async {
    if (currentConversationId.value == null) {
      Get.snackbar("Error", "No conversation selected to create a ticket.");
      return null;
    }
    try {
      isGeneratingTicket.value = true;
      final draft = await _service.createTicketFromChat(
        conversationId: currentConversationId.value!,
      );
      return draft;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not generate ticket draft: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isGeneratingTicket.value = false;
    }
  }

  /// Edit a user's previous message, truncating the subsequent messages list
  Future<void> editUserMessage(String messageId, String newText) async {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    // Keep all messages before this index
    final preservedMessages = messages.sublist(0, index);

    if (currentConversationId.value != null) {
      try {
        isTyping.value = true;
        // Truncate in DB by updating the message history
        final apiMessages = preservedMessages
            .map(
              (m) => {
                "role": m.role,
                "message": m.message,
                "timestamp": m.createdAt.toIso8601String(),
              },
            )
            .toList();

        await _service.updateConversation(
          currentConversationId.value!,
          messages: apiMessages,
        );

        // Truncate locally
        messages.assignAll(preservedMessages);

        // Resend as edited
        await sendMessage(customText: newText);
      } catch (e) {
        Get.snackbar("Error", "Failed to edit message: $e");
      } finally {
        isTyping.value = false;
      }
    } else {
      // For a new unsaved chat, just clear subsequent messages and resend
      messages.assignAll(preservedMessages);
      await sendMessage(customText: newText);
    }
  }

  /// Delete conversation session
  Future<void> deleteConversation(String id) async {
    try {
      await _service.deleteConversation(id);
      conversations.removeWhere((c) => c.id == id);

      // If deleted is active conversation, start new chat
      if (currentConversationId.value == id) {
        startNewChat();
      }
      Get.snackbar(
        "Deleted",
        "Conversation deleted",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Delete Error",
        "Could not delete conversation: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pin or Unpin conversation
  Future<void> togglePinConversation(String id, bool isPinned) async {
    try {
      final updated = await _service.updateConversation(id, isPinned: isPinned);

      // Update in local list
      final index = conversations.indexWhere((c) => c.id == id);
      if (index != -1) {
        conversations[index] = updated;

        // Re-sort list: pinned first, then by updatedAt desc
        conversations.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
      }
    } catch (e) {
      Get.snackbar(
        "Pin Error",
        "Failed to update pin status: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Rename conversation
  Future<void> renameConversation(String id, String newTitle) async {
    if (newTitle.trim().isEmpty) return;
    try {
      final updated = await _service.updateConversation(
        id,
        title: newTitle.trim(),
      );

      final index = conversations.indexWhere((c) => c.id == id);
      if (index != -1) {
        conversations[index] = updated;
      }

      if (currentConversationId.value == id) {
        currentConversationTitle.value = updated.title;
      }
    } catch (e) {
      Get.snackbar(
        "Rename Error",
        "Failed to rename conversation: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Copy message content to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied",
      "Message text copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Get filtered conversations based on search query
  List<AIConversationModel> get filteredConversations {
    final query = searchConversationsQuery.value.toLowerCase().trim();
    if (query.isEmpty) return conversations;
    return conversations
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();
  }

  /// Clear the active conversation messages (but don't delete history session)
  void clearActiveConversation() {
    messages.clear();
    canCreateTicket.value = false;
    failedMessageIds.clear();
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
