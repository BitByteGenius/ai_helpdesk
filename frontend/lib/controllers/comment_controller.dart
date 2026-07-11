import 'package:flutter/material.dart';
import 'package:frontend/servicies/comment_service.dart';
import 'package:get/get.dart';

import '../models/comment_model.dart';
import 'socket_controller.dart';

class CommentController extends GetxController {
  final CommentService _service;

  CommentController(this._service);

  late SocketController socket;

  /// Current Ticket
  final RxString ticketId = "".obs;

  /// Comments
  final RxList<CommentModel> comments =
      <CommentModel>[].obs;

  /// Loading
  final RxBool isLoading = false.obs;

  /// Input
  final TextEditingController messageController =
      TextEditingController();

  /// Scroll
  final ScrollController scrollController =
      ScrollController();

  @override
  void onInit() {
    super.onInit();

    socket = Get.find<SocketController>();

    socket.onCommentAdded(_receiveComment);
  }

  /// Load Comments
  Future<void> loadComments(
    String id,
  ) async {
    ticketId.value = id;

    try {
      isLoading.value = true;

      comments.assignAll(
        await _service.getComments(id),
      );

      scrollToBottom();
    } finally {
      isLoading.value = false;
    }
  }

  /// Add Comment
  Future<void> sendComment() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final comment =
        await _service.addComment(
      ticketId: ticketId.value,
      message: messageController.text.trim(),
    );

    comments.add(comment);

    messageController.clear();

    scrollToBottom();
  }

  /// Delete
  Future<void> deleteComment(
    String id,
  ) async {
    await _service.deleteComment(id);

    comments.removeWhere(
      (e) => e.id == id,
    );
  }

  /// Socket Event
  void _receiveComment(dynamic data) {
    final payload = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data as Map);

    final action = payload["action"]?.toString();
    if (action == "deleted") {
      final deletedId = payload["commentId"]?.toString();
      if (deletedId != null && deletedId.isNotEmpty) {
        comments.removeWhere((e) => e.id == deletedId);
      }
      return;
    }

    final commentJson = payload["comment"] is Map
        ? Map<String, dynamic>.from(payload["comment"] as Map)
        : payload;

    final comment = CommentModel.fromJson(commentJson);

    if (comment.ticketId != ticketId.value) {
      return;
    }

    final exists = comments.any(
      (e) => e.id == comment.id,
    );

    if (!exists) {
      comments.add(comment);

      scrollToBottom();
    }
  }

  /// Scroll
  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  /// Update Comment
  Future<void> updateComment(
    String id,
    String message,
  ) async {
    final updated = await _service.updateComment(id, message);

    final index = comments.indexWhere((e) => e.id == id);
    if (index != -1) {
      comments[index] = updated;
    }
  }

  @override
  void onClose() {
    socket.remove("comment:update");
    socket.remove("comment:new");
    socket.remove("comment-added");

    messageController.dispose();

    scrollController.dispose();

    super.onClose();
  }
}
