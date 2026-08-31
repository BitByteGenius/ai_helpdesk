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
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          /// File Icon / Preview
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.surfaceSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: upload.isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      upload.url,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Icon(
                        Icons.image_outlined,
                        size: 24,
                        color: context.textSecondary,
                      ),
                    ),
                  )
                : Icon(
                    upload.isPdf
                        ? Icons.picture_as_pdf_outlined
                        : Icons.insert_drive_file_outlined,
                    size: 26,
                    color: upload.isPdf ? AppColors.error : context.primaryColor,
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
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.surfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        upload.fileType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      upload.formattedSize,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textMuted,
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
            icon: Icon(
              Icons.visibility_outlined,
              size: 20,
              color: context.primaryColor,
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
                backgroundColor: context.cardBg,
                title: "Delete File",
                titleStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: context.textPrimary),
                middleText: "Are you sure you want to delete this file permanently?",
                middleTextStyle: TextStyle(color: context.textSecondary, fontSize: 13),
                textCancel: "Cancel",
                textConfirm: "Delete",
                cancelTextColor: context.textPrimary,
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