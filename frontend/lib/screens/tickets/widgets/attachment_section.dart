import 'package:flutter/material.dart';
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

    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Attachments",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: ticket.attachments
                  .map((attachment) => _AttachmentTile(
                        fileName: attachment.fileName,
                        url: attachment.url,
                      ))
                  .toList(),
            ),
          ],
        ),
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
      return Icons.picture_as_pdf;
    }

    if (file.endsWith(".png") ||
        file.endsWith(".jpg") ||
        file.endsWith(".jpeg") ||
        file.endsWith(".webp")) {
      return Icons.image;
    }

    if (file.endsWith(".doc") ||
        file.endsWith(".docx")) {
      return Icons.description;
    }

    if (file.endsWith(".xls") ||
        file.endsWith(".xlsx")) {
      return Icons.table_chart;
    }

    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final uri = Uri.tryParse(url);

        if (uri == null) {
          Get.snackbar(
            "Error",
            "Invalid attachment URL",
          );
          return;
        }

        if (!await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        )) {
          Get.snackbar(
            "Error",
            "Unable to open attachment",
          );
        }
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: .3),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                _icon(fileName),
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Click to open",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.open_in_new),
          ],
        ),
      ),
    );
  }
}