import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/comment_model.dart';

class CommentBubble extends StatelessWidget {
  final CommentModel comment;
  final bool isMine;

  const CommentBubble({
    super.key,
    required this.comment,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? context.primaryColor : (context.isDark ? const Color(0xFF334155) : AppColors.surfaceSubtle);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: isMine ? const Radius.circular(14) : Radius.zero,
            bottomRight: isMine ? Radius.zero : const Radius.circular(14),
          ),
          border: isMine ? null : Border.all(color: context.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.user.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: isMine ? Colors.white.withValues(alpha: 0.9) : context.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              comment.message,
              style: TextStyle(
                color: isMine ? Colors.white : context.textPrimary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 10,
                  color: isMine ? Colors.white.withValues(alpha: 0.6) : context.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}