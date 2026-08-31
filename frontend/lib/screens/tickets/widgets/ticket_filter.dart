import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class TicketFilter extends GetView<TicketController> {
  const TicketFilter({super.key});

  static const List<String> statuses = [
    "",
    "Open",
    "Assigned",
    "In Progress",
    "Resolved",
    "Closed",
    "Rejected",
  ];

  static const List<String> priorities = [
    "",
    "Low",
    "Medium",
    "High",
    "Critical",
  ];

  static const List<String> categories = [
    "",
    "Hardware",
    "Software",
    "Network",
    "Email",
    "Security",
    "Account",
    "Printer",
    "Internet",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildDropdown(
            context: context,
            label: "Status",
            value: controller.selectedStatus.value,
            items: statuses,
            onChanged: (value) {
              controller.filterStatus(value ?? "");
            },
          ),
          _buildDropdown(
            context: context,
            label: "Priority",
            value: controller.selectedPriority.value,
            items: priorities,
            onChanged: (value) {
              controller.filterPriority(value ?? "");
            },
          ),
          _buildDropdown(
            context: context,
            label: "Category",
            value: controller.selectedCategory.value,
            items: categories,
            onChanged: (value) {
              controller.filterCategory(value ?? "");
            },
          ),
          OutlinedButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text("Clear Filters", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              side: BorderSide(color: context.border),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : items.first,
        dropdownColor: context.cardBg,
        style: TextStyle(fontSize: 13, color: context.textPrimary, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12, color: context.textSecondary),
          filled: true,
          fillColor: context.surfaceSubtle,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.border),
          ),
        ),
        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e.isEmpty ? "All $label" : e,
              style: TextStyle(fontSize: 13, color: context.textPrimary),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}