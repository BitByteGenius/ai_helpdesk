import 'package:flutter/material.dart';
import 'package:frontend/servicies/ai_service.dart';
import 'package:get/get.dart';

import '../models/ai_analysis_model.dart';

class AiController extends GetxController {
  final AiService _service = AiService();

  /// Loading
  final RxBool isLoading = false.obs;

  /// AI Result
  final Rxn<AiAnalysisModel> analysis = Rxn<AiAnalysisModel>();

  /// Error
  final RxString error = "".obs;

  /// Analyze Ticket
  Future<void> analyzeTicket({
    required String title,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      error.value = "";

      final result = await _service.analyzeTicket(
        title: title,
        description: description,
      );

      analysis.value = result;

      Get.snackbar(
        "AI Analysis Complete",
        "Category, Priority and Summary generated.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();

      Get.snackbar(
        "AI Error",
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate AI Reply
  Future<String> generateReply({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) async {
    try {
      return await _service.generateReply(
        title: title,
        description: description,
        category: category,
        priority: priority,
      );
    } catch (e) {
      Get.snackbar(
        "AI Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      return "";
    }
  }

  /// Clear Previous Analysis
  void clearAnalysis() {
    analysis.value = null;
    error.value = "";
  }
}