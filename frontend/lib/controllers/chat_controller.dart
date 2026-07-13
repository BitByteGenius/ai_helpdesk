import 'package:flutter/material.dart';
import 'package:frontend/servicies/comment_service.dart';
import 'package:get/get.dart';
import '../models/comment_model.dart';
import 'socket_controller.dart';

class ChatController extends GetxController {
  final CommentService _service;

  ChatController(this._service);

  late SocketController socket;

  final RxString activeTicketId = "".obs;
  final RxList<CommentModel> messagesList = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    socket = Get.find<SocketController>();
    socket.onCommentAdded(_receiveComment);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadMessages(String ticketId) async {
    activeTicketId.value = ticketId;
    try {
      isLoading.value = true;
      final list = await _service.getComments(ticketId);
      messagesList.assignAll(list);
      scrollToBottom();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String ticketId, String text) async {
    if (text.trim().isEmpty) return;
    try {
      isUpdating.value = true;
      final comment = await _service.addComment(
        ticketId: ticketId,
        message: text.trim(),
      );
      messagesList.add(comment);
      scrollToBottom();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdating.value = false;
    }
  }

  void _receiveComment(dynamic data) {
    try {
      final payload = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data as Map);

      final action = payload["action"]?.toString();
      if (action == "deleted") {
        final deletedId = payload["commentId"]?.toString();
        if (deletedId != null && deletedId.isNotEmpty) {
          messagesList.removeWhere((e) => e.id == deletedId);
        }
        return;
      }

      final commentJson = payload["comment"] is Map
          ? Map<String, dynamic>.from(payload["comment"] as Map)
          : payload;

      final comment = CommentModel.fromJson(commentJson);

      if (comment.ticketId != activeTicketId.value) {
        return;
      }

      final exists = messagesList.any((e) => e.id == comment.id);
      if (!exists) {
        messagesList.add(comment);
        scrollToBottom();
      }
    } catch (_) {}
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }
}
