import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/comment_controller.dart';
import 'comment_bubble.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final commentController = Get.find<CommentController>();
    final authController = Get.find<AuthController>();

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        if (commentController.isLoading.value) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (commentController.comments.isEmpty) {
          return SizedBox(
            height: 140,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 36,
                    color: context.textMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "No comments yet",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Start the discussion below.",
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentController.comments.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final comment = commentController.comments[index];
            return CommentBubble(
              comment: comment,
              isMine: comment.user.id == authController.user?.id,
            );
          },
        );
      }),
    );
  }
}