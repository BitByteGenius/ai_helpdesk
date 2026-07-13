import 'package:flutter/material.dart';
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

    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Padding(
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
              height: 160,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 42,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "No comments yet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Start the discussion below.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
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
            separatorBuilder: (_, _) =>
                const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final comment =
                  commentController.comments[index];

              return CommentBubble(
                comment: comment,
                isMine:
                    comment.user.id ==
                    authController.user?.id,
              );
            },
          );
        }),
      ),
    );
  }
}