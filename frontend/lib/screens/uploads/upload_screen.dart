import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/uploads/widget/upload_card.dart';
import 'package:frontend/screens/uploads/widget/upload_progress.dart';
import 'package:get/get.dart';
import '../../controllers/upload_controller.dart';

class UploadScreen extends GetView<UploadController> {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'File Manager',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return Obx(() {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "System File Uploads",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Supported formats: JPG, PNG, WEBP, PDF, DOC, DOCX (Max 25MB)",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          FilledButton.icon(
                            onPressed: controller.pickAndUpload,
                            icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                            label: const Text("Upload File", style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Upload drop area
                      InkWell(
                        onTap: controller.pickAndUpload,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySubtle,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.cloud_upload_rounded, size: 32, color: AppColors.primary),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Click to select a file from your device",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Files will be processed and indexed automatically",
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const UploadProgress(),

                      const SizedBox(height: 16),

                      if (controller.uploads.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                size: 48,
                                color: AppColors.textMuted,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No uploaded files found",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          itemCount: controller.uploads.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            return UploadCard(
                              upload: controller.uploads[index],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

