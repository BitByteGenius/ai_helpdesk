import 'package:flutter/material.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class CommentInput extends GetView<CommentController> {
  const CommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              style: TextStyle(fontSize: 13, color: context.textPrimary),
              decoration: InputDecoration(
                hintText: "Write a message or reply...",
                hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
                isDense: true,
                filled: true,
                fillColor: context.surfaceSubtle,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendComment(),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            icon: const Icon(Icons.send_rounded, size: 18),
            onPressed: controller.sendComment,
            style: IconButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}