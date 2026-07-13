import 'package:flutter/material.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:get/get.dart';


class CommentInput extends GetView<CommentController> {
  const CommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller:
                    controller.messageController,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            CircleAvatar(
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: controller.sendComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}