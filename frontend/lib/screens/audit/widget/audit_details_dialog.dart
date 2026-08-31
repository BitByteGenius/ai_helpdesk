import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuditDetailsDialog extends GetView<AuditController> {
  const AuditDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: context.cardBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Obx(() {
          final audit = controller.selectedAudit.value;

          if (audit == null) {
            return const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _actionColor(audit.action).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_actionIcon(audit.action), color: _actionColor(audit.action), size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Audit Event Inspection",
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: context.textPrimary, letterSpacing: -0.2),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _actionColor(audit.action).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  audit.action,
                                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: _actionColor(audit.action)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "ID: ${audit.id}",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: context.textMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: "Copy Event ID",
                      icon: Icon(Icons.copy_rounded, size: 18, color: context.textSecondary),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: audit.id));
                        Get.snackbar("Copied", "Audit Log ID copied to clipboard", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
                      },
                    ),
                    IconButton(
                      tooltip: "Close",
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: Get.back,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(height: 1, color: context.borderLight),
                const SizedBox(height: 18),

                // ── User Actor Card ──
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.surfaceSubtle,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: context.primaryColor.withValues(alpha: 0.15),
                        child: Text(
                          audit.user.name.isNotEmpty ? audit.user.name[0].toUpperCase() : "U",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  audit.user.name.isNotEmpty ? audit.user.name : "System Anonymous",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: context.textPrimary),
                                ),
                                if (audit.user.role.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: context.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      audit.user.role.toUpperCase(),
                                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: context.primaryColor),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              audit.user.email.isNotEmpty ? audit.user.email : "No email associated",
                              style: TextStyle(fontSize: 12, color: context.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Event Metadata Grid ──
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _metaChip(context, Icons.category_outlined, "Entity", audit.entity),
                    _metaChip(context, Icons.access_time_rounded, "Timestamp", DateFormat("dd MMM yyyy, hh:mm:ss a").format(audit.createdAt)),
                    _metaChip(context, Icons.router_rounded, "IP Address", audit.ipAddress.isNotEmpty ? audit.ipAddress : "127.0.0.1"),
                    if (audit.userAgent.isNotEmpty)
                      _metaChip(context, Icons.devices_rounded, "Client", audit.userAgent),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Description Box ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activity Description",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: context.textSecondary, letterSpacing: 0.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        audit.description,
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: context.textPrimary, height: 1.4),
                      ),
                    ],
                  ),
                ),

                // ── State Diff Viewers ──
                if (audit.oldData != null || audit.newData != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    "State Mutation Payload (Diff)",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: context.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  if (audit.oldData != null) ...[
                    _buildJsonBox(
                      title: "Previous State (Before Mutation)",
                      data: audit.oldData!,
                      borderColor: AppColors.error.withValues(alpha: 0.3),
                      badgeColor: AppColors.error.withValues(alpha: 0.1),
                      textColor: AppColors.error,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (audit.newData != null) ...[
                    _buildJsonBox(
                      title: "New State (After Mutation)",
                      data: audit.newData!,
                      borderColor: AppColors.success.withValues(alpha: 0.3),
                      badgeColor: AppColors.success.withValues(alpha: 0.1),
                      textColor: AppColors.success,
                    ),
                  ],
                ],

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: Get.back,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _metaChip(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.textSecondary),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: context.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: context.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonBox({
    required String title,
    required Map<String, dynamic> data,
    required Color borderColor,
    required Color badgeColor,
    required Color textColor,
  }) {
    String prettyJson;
    try {
      prettyJson = const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      prettyJson = data.toString();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Slate 900 code box
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textColor),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: prettyJson));
                    Get.snackbar("Copied", "JSON copied to clipboard", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_rounded, size: 12, color: Color(0xFF94A3B8)),
                      SizedBox(width: 4),
                      Text("Copy JSON", style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              prettyJson,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF38BDF8), // Light sky JSON text
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _actionColor(String action) {
    switch (action.toUpperCase()) {
      case "LOGIN":
      case "REGISTER":
        return AppColors.success;
      case "CREATE":
        return AppColors.primary;
      case "UPDATE":
      case "STATUS_CHANGE":
      case "ASSIGN":
        return AppColors.warning;
      case "DELETE":
        return AppColors.error;
      case "AI_ANALYSIS":
        return AppColors.purple;
      default:
        return AppColors.info;
    }
  }

  IconData _actionIcon(String action) {
    switch (action.toUpperCase()) {
      case "LOGIN":
      case "REGISTER":
        return Icons.login_rounded;
      case "CREATE":
        return Icons.add_circle_outline_rounded;
      case "UPDATE":
      case "STATUS_CHANGE":
        return Icons.edit_note_rounded;
      case "ASSIGN":
        return Icons.person_add_alt_1_rounded;
      case "DELETE":
        return Icons.delete_outline_rounded;
      case "AI_ANALYSIS":
        return Icons.auto_awesome_rounded;
      case "COMMENT":
        return Icons.chat_bubble_outline_rounded;
      case "UPLOAD":
        return Icons.upload_file_rounded;
      default:
        return Icons.flash_on_rounded;
    }
  }
}