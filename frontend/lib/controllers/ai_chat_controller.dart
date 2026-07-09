import 'package:flutter/material.dart';
import 'package:frontend/models/ai_model/ai_chat_model.dart';
import 'package:frontend/models/ai_model/ai_message_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


import '../servicies/ai_chat_service.dart';

class AIChatController extends GetxController {
  final AIChatService _service;

  AIChatController(this._service);

  final messages = <AIMessageModel>[].obs;

  final inputController =
      TextEditingController();

  final isTyping = false.obs;

  final Rxn<AIChatModel> lastResponse =
      Rxn<AIChatModel>();

  Future<void> sendMessage() async {
    final text = inputController.text.trim();

    if (text.isEmpty) return;

    messages.add(
      AIMessageModel(
        message: text,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    inputController.clear();

    isTyping.value = true;

    try {
      final response =
          await _service.chat(
        message: text,
      );

      lastResponse.value = response;

      messages.add(
        AIMessageModel(
          message: response.reply,
          isUser: false,
          time: DateTime.now(),
        ),
      );
    } catch (e) {
      messages.add(
        AIMessageModel(
          message:
              "Sorry, something went wrong.",
          isUser: false,
          time: DateTime.now(),
        ),
      );
    }

    isTyping.value = false;
  }
}