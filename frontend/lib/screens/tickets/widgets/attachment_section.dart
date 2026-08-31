import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/ticket_model.dart';

class AttachmentSection extends StatelessWidget {
  final TicketModel ticket;

  const AttachmentSection({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    if (ticket.attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                "Attachments",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${ticket.attachments.length}",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ticket.attachments
                .map((attachment) => _AttachmentTile(
                      fileName: attachment.fileName,
                      url: attachment.url,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String fileName;
  final String url;

  const _AttachmentTile({
    required this.fileName,
    required this.url,
  });

  IconData _icon(String name) {
    final file = name.toLowerCase();
    if (file.endsWith(".pdf")) {
      return Icons.picture_as_pdf_rounded;
    }
    if (file.endsWith(".png") ||
        file.endsWith(".jpg") ||
        file.endsWith(".jpeg") ||
        file.endsWith(".webp")) {
      return Icons.image_rounded;
    }
    if (file.endsWith(".doc") || file.endsWith(".docx")) {
      return Icons.description_rounded;
    }
    if (file.endsWith(".xls") || file.endsWith(".xlsx")) {
      return Icons.table_chart_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final uri = Uri.tryParse(url);
          if (uri == null) {
            Get.snackbar("Error", "Invalid attachment URL", snackPosition: SnackPosition.BOTTOM);
            return;
          }
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            Get.snackbar("Error", "Unable to open attachment", snackPosition: SnackPosition.BOTTOM);
          }
        },
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _icon(fileName),
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Click to open",
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}