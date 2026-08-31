import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/upload_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadPreview extends StatelessWidget {
  final UploadModel upload;

  const UploadPreview({
    super.key,
    required this.upload,
  });

  Future<void> _openFile() async {
    final uri = Uri.parse(upload.url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImage = upload.isImage;

    return Scaffold(
      backgroundColor: context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(upload.originalName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 20),
            tooltip: "Open in External App",
            onPressed: _openFile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isImage
              ? InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Image.network(
                    upload.url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image_outlined, size: 48, color: AppColors.error),
                          const SizedBox(height: 12),
                          Text("Unable to load image preview.", style: TextStyle(color: context.textSecondary)),
                        ],
                      );
                    },
                  ),
                )
              : Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: (upload.isPdf ? AppColors.error : context.primaryColor).withValues(alpha: context.isDark ? 0.16 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          upload.isPdf ? Icons.picture_as_pdf_outlined : Icons.insert_drive_file_outlined,
                          size: 48,
                          color: upload.isPdf ? AppColors.error : context.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        upload.originalName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${upload.fileType.toUpperCase()} • ${upload.formattedSize}",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: FilledButton.icon(
                          onPressed: _openFile,
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text("Open in External Browser", style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}