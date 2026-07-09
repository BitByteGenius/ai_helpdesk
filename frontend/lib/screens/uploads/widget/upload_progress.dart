import 'package:flutter/material.dart';
import 'package:frontend/controllers/upload_controller.dart';
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

      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      "Uploading...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
      );
    });
  }
}