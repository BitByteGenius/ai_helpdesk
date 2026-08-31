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
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
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
                  Icon(Icons.filter_list_rounded, size: 16, color: context.textSecondary),
                  const SizedBox(width: 8),
                  Text("Quick Filters:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                  const SizedBox(width: 10),
                  _buildQuickPill(
                    context: context,
                    label: "All Events",
                    selected: activeAction.isEmpty && activeEntity.isEmpty,
                    onTap: controller.clearFilters,
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    context: context,
                    label: "Logins & Security",
                    selected: activeAction == "LOGIN" || activeEntity == "AUTH",
                    onTap: () {
                      controller.filterAction("LOGIN");
                      controller.filterEntity("AUTH");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    context: context,
                    label: "Tickets",
                    selected: activeEntity == "TICKET",
                    onTap: () {
                      controller.filterAction("");
                      controller.filterEntity("TICKET");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    context: context,
                    label: "AI Telemetry",
                    selected: activeAction == "AI_ANALYSIS" || activeEntity == "AI",
                    onTap: () {
                      controller.filterAction("AI_ANALYSIS");
                      controller.filterEntity("AI");
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    context: context,
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
          Divider(height: 1, color: context.borderLight),
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
                    dropdownColor: context.cardBg,
                    style: TextStyle(fontSize: 13, color: context.textPrimary, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: "Action Filter",
                      prefixIcon: Icon(Icons.flash_on_rounded, size: 18, color: context.primaryColor),
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
                    dropdownColor: context.cardBg,
                    style: TextStyle(fontSize: 13, color: context.textPrimary, fontWeight: FontWeight.w500),
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
                  side: BorderSide(color: context.border),
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
    required BuildContext context,
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
          color: selected ? context.primaryColor : context.surfaceSubtle,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.primaryColor : context.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : context.textPrimary,
          ),
        ),
      ),
    );
  }
}