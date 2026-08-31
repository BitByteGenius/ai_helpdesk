import 'package:flutter/material.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class UploadProgress extends GetView<UploadController> {
  const UploadProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isUploading.value) {
        return const SizedBox.shrink();
      }

      final progress = controller.progress.value;

      return Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.primarySubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Uploading file...",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: context.surfaceSubtle,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}