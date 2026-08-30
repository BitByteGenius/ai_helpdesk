import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class AuditFilter extends GetView<AuditController> {
  const AuditFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Quick Filter Pills ──
          Obx(() {
            final activeAction = controller.selectedAction.value;
            final activeEntity = controller.selectedEntity.value;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.filter_list_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  const Text("Quick Filters:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(width: 10),
                  _buildQuickPill(
                    label: "All Events",
                    selected: activeAction.isEmpty && activeEntity.isEmpty,
                    onTap: controller.clearFilters,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    label: "Logins & Security",
                    selected: activeAction == "LOGIN" || activeEntity == "AUTH",
                    onTap: () {
                      controller.filterAction("LOGIN");
                      controller.filterEntity("AUTH");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    label: "Tickets",
                    selected: activeEntity == "TICKET",
                    onTap: () {
                      controller.filterAction("");
                      controller.filterEntity("TICKET");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    label: "AI Telemetry",
                    selected: activeAction == "AI_ANALYSIS" || activeEntity == "AI",
                    onTap: () {
                      controller.filterAction("AI_ANALYSIS");
                      controller.filterEntity("AI");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    label: "Mutations (Create/Update)",
                    selected: activeAction == "CREATE" || activeAction == "UPDATE",
                    onTap: () {
                      controller.filterAction("CREATE");
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 16),

          // ── Dropdowns & Reset ──
          Wrap(
            spacing: 14,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: Obx(() {
                  final val = controller.selectedAction.value;
                  return DropdownButtonFormField<String>(
                    initialValue: val.isEmpty ? null : val,
                    decoration: const InputDecoration(
                      labelText: "Action Filter",
                      prefixIcon: Icon(Icons.flash_on_rounded, size: 18, color: AppColors.primary),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: "", child: Text("All Actions")),
                      DropdownMenuItem(value: "LOGIN", child: Text("LOGIN")),
                      DropdownMenuItem(value: "REGISTER", child: Text("REGISTER")),
                      DropdownMenuItem(value: "CREATE", child: Text("CREATE")),
                      DropdownMenuItem(value: "UPDATE", child: Text("UPDATE")),
                      DropdownMenuItem(value: "DELETE", child: Text("DELETE")),
                      DropdownMenuItem(value: "ASSIGN", child: Text("ASSIGN")),
                      DropdownMenuItem(value: "STATUS_CHANGE", child: Text("STATUS CHANGE")),
                      DropdownMenuItem(value: "COMMENT", child: Text("COMMENT")),
                      DropdownMenuItem(value: "UPLOAD", child: Text("UPLOAD")),
                      DropdownMenuItem(value: "AI_ANALYSIS", child: Text("AI ANALYSIS")),
                    ],
                    onChanged: (value) {
                      controller.filterAction(value ?? "");
                    },
                  );
                }),
              ),
              SizedBox(
                width: 220,
                child: Obx(() {
                  final val = controller.selectedEntity.value;
                  return DropdownButtonFormField<String>(
                    initialValue: val.isEmpty ? null : val,
                    decoration: const InputDecoration(
                      labelText: "Entity Type",
                      prefixIcon: Icon(Icons.category_outlined, size: 18, color: AppColors.secondary),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: "", child: Text("All Entities")),
                      DropdownMenuItem(value: "AUTH", child: Text("AUTH")),
                      DropdownMenuItem(value: "TICKET", child: Text("TICKET")),
                      DropdownMenuItem(value: "PROFILE", child: Text("PROFILE")),
                      DropdownMenuItem(value: "COMMENT", child: Text("COMMENT")),
                      DropdownMenuItem(value: "UPLOAD", child: Text("UPLOAD")),
                      DropdownMenuItem(value: "AI", child: Text("AI")),
                    ],
                    onChanged: (value) {
                      controller.filterEntity(value ?? "");
                    },
                  );
                }),
              ),

              OutlinedButton.icon(
                onPressed: controller.clearFilters,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  side: const BorderSide(color: AppColors.border),
                ),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text("Reset All", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
