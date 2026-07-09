import 'package:flutter/material.dart';
import 'package:frontend/models/ai_model/ai_message_model.dart';


class AIMessageBubble extends StatelessWidget {
  final AIMessageModel message;

  const AIMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment:
          isUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color:
                isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}