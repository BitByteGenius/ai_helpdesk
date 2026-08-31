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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: "Write a message or reply...",
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                isDense: true,
                filled: true,
                fillColor: AppColors.surfaceSubtle,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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