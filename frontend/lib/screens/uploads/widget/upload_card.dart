import 'package:flutter/material.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/upload_model.dart';
import 'package:get/get.dart';

class UploadCard extends StatelessWidget {
  final UploadModel upload;

  const UploadCard({
    super.key,
    required this.upload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          /// File Icon / Preview
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: upload.isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      upload.url,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(
                        Icons.image_outlined,
                        size: 24,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : Icon(
                    upload.isPdf
                        ? Icons.picture_as_pdf_outlined
                        : Icons.insert_drive_file_outlined,
                    size: 26,
                    color: upload.isPdf ? AppColors.error : AppColors.primary,
                  ),
          ),

          const SizedBox(width: 14),

          /// File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upload.originalName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        upload.fileType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      upload.formattedSize,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// View Button
          IconButton(
            tooltip: "Preview",
            icon: const Icon(
              Icons.visibility_outlined,
              size: 20,
              color: AppColors.primary,
            ),
            onPressed: () {
              Get.toNamed(
                "/upload-preview",
                arguments: upload,
              );
            },
          ),

          /// Delete Button
          IconButton(
            tooltip: "Delete",
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppColors.error,
            ),
            onPressed: () {
              Get.defaultDialog(
                title: "Delete File",
                titleStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                middleText: "Are you sure you want to delete this file permanentely?",
                textCancel: "Cancel",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
                buttonColor: AppColors.error,
                onConfirm: () {
                  Get.back();
                  Get.find<UploadController>().deleteUpload(upload.id);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}