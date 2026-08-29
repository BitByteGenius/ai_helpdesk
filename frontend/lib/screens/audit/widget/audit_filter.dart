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
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Obx(() {
              return DropdownButtonFormField<String>(
                initialValue: controller.selectedAction.value.isEmpty ? null : controller.selectedAction.value,
                decoration: const InputDecoration(
                  labelText: "Filter Action",
                  prefixIcon: Icon(Icons.flash_on_rounded, size: 18),
                  isDense: true,
                ),
                items: const [
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
            width: 200,
            child: Obx(() {
              return DropdownButtonFormField<String>(
                initialValue: controller.selectedEntity.value.isEmpty ? null : controller.selectedEntity.value,
                decoration: const InputDecoration(
                  labelText: "Filter Entity",
                  prefixIcon: Icon(Icons.category_outlined, size: 18),
                  isDense: true,
                ),

                items: const [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              side: const BorderSide(color: AppColors.border),
            ),
            icon: const Icon(Icons.clear_all_rounded, size: 18),
            label: const Text("Reset Filters", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}