import 'package:flutter/material.dart';
import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:get/get.dart';


class AIInputBar extends GetView<AIChatController> {
  const AIInputBar({super.key});

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
                    controller.inputController,

                decoration: InputDecoration(
                  hintText:
                      "Describe your issue...",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),

                onSubmitted: (_) {
                  controller.sendMessage();
                },
              ),
            ),

            const SizedBox(width: 12),

            CircleAvatar(
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed:
                    controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}