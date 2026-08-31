import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/audit_model.dart';
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
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  "Fetching audit trail records...",
                  style: TextStyle(fontSize: 13, color: context.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.audits.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.surfaceSubtle,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.history_toggle_off_rounded, size: 40, color: context.textMuted),
                ),
                const SizedBox(height: 16),
                Text(
                  "No audit logs found matching criteria",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  "Try adjusting your action or entity filters above to see more records.",
                  style: TextStyle(fontSize: 13, color: context.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                FilledButton.tonalIcon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text("Clear Active Filters"),
                ),
              ],
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Table Header Bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Icon(Icons.list_alt_rounded, size: 18, color: context.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Audit Trail History",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: context.textPrimary),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.primarySubtle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${controller.audits.length} Records",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: context.borderLight),

                // ── Content: Desktop Data Table or Mobile Card List ──
                if (isMobile)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.audits.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final audit = controller.audits[index];
                      return _buildMobileCard(context, audit);
                    },
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        horizontalMargin: 20,
                        columnSpacing: 24,
                        headingRowColor: WidgetStateProperty.all(context.surfaceSubtle),
                        headingTextStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                          color: context.textSecondary,
                          letterSpacing: 0.6,
                        ),
                        columns: const [
                          DataColumn(label: Text("USER / ACTOR")),
                          DataColumn(label: Text("ACTION")),
                          DataColumn(label: Text("ENTITY")),
                          DataColumn(label: Text("DESCRIPTION")),
                          DataColumn(label: Text("IP / CLIENT")),
                          DataColumn(label: Text("TIMESTAMP")),
                          DataColumn(label: Text("ACTIONS")),
                        ],
                        rows: controller.audits.map((audit) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: context.primaryColor.withValues(alpha: 0.12),
                                      child: Text(
                                        audit.user.name.isNotEmpty ? audit.user.name[0].toUpperCase() : "U",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: context.primaryColor),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          audit.user.name.isNotEmpty ? audit.user.name : "System / Anonymous",
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textPrimary),
                                        ),
                                        if (audit.user.role.isNotEmpty)
                                          Text(
                                            audit.user.role.toUpperCase(),
                                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: context.textMuted),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                _buildActionBadge(audit.action),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: context.surfaceSubtle,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: context.border),
                                  ),
                                  child: Text(
                                    audit.entity,
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: context.textSecondary),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 260,
                                  child: Text(
                                    audit.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12.5, color: context.textPrimary),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  audit.ipAddress.isNotEmpty ? audit.ipAddress : "—",
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: context.textSecondary),
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat("dd MMM yyyy").format(audit.createdAt),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary),
                                    ),
                                    Text(
                                      DateFormat("hh:mm:ss a").format(audit.createdAt),
                                      style: TextStyle(fontSize: 11, color: context.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                InkWell(
                                  onTap: () async {
                                    await controller.openAudit(audit.id);
                                    Get.dialog(const AuditDetailsDialog());
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: context.primarySubtle,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.visibility_outlined, size: 14, color: context.primaryColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Inspect",
                                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: context.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildActionBadge(String action) {
    final color = _actionColor(action);
    final icon = _actionIcon(action);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            action,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(BuildContext context, AuditModel audit) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildActionBadge(audit.action),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: context.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  audit.entity,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat("dd MMM, hh:mm a").format(audit.createdAt),
                style: TextStyle(fontSize: 11, color: context.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            audit.description,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: context.primaryColor.withValues(alpha: 0.12),
                child: Text(
                  audit.user.name.isNotEmpty ? audit.user.name[0].toUpperCase() : "U",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: context.primaryColor),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                audit.user.name,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textSecondary),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  await controller.openAudit(audit.id);
                  Get.dialog(const AuditDetailsDialog());
                },
                icon: const Icon(Icons.visibility_outlined, size: 14),
                label: const Text("Inspect", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
            ],
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