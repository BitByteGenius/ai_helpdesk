import 'package:flutter/material.dart';
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
    return Align(
      alignment:
          isMine
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(
          maxWidth: 380,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? Colors.blue
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              comment.user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMine
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              comment.message,
              style: TextStyle(
                color: isMine
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 11,
                  color: isMine
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}