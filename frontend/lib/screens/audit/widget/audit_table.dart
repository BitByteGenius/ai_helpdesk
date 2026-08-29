import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/screens/audit/widget/audit_details_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuditTable extends GetView<AuditController> {
  const AuditTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.audits.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(
            children: [
              Icon(Icons.history_toggle_off_rounded, size: 48, color: AppColors.textMuted),
              SizedBox(height: 12),
              Text(
                "No audit logs found matching criteria",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            horizontalMargin: 20,
            columnSpacing: 24,
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceSubtle),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
            columns: const [
              DataColumn(label: Text("USER")),
              DataColumn(label: Text("ACTION")),
              DataColumn(label: Text("ENTITY")),
              DataColumn(label: Text("DESCRIPTION")),
              DataColumn(label: Text("TIMESTAMP")),
              DataColumn(label: Text("DETAILS")),
            ],
            rows: controller.audits.map((audit) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            audit.user.name.isNotEmpty ? audit.user.name[0].toUpperCase() : "U",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          audit.user.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _actionColor(audit.action).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        audit.action,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _actionColor(audit.action),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      audit.entity,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 280,
                      child: Text(
                        audit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      DateFormat("dd MMM yyyy, hh:mm a").format(audit.createdAt),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.primary),
                      tooltip: "View Details",
                      onPressed: () async {
                        await controller.openAudit(audit.id);
                        Get.dialog(const AuditDetailsDialog());
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
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
        return AppColors.textSecondary;
    }
  }
}