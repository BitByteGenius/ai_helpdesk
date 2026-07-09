import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
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
            label: "Status",
            value: controller.selectedStatus.value,
            items: statuses,
            onChanged: (value) {
              controller.filterStatus(value ?? "");
            },
          ),

          _buildDropdown(
            label: "Priority",
            value: controller.selectedPriority.value,
            items: priorities,
            onChanged: (value) {
              controller.filterPriority(value ?? "");
            },
          ),

          _buildDropdown(
            label: "Category",
            value: controller.selectedCategory.value,
            items: categories,
            onChanged: (value) {
              controller.filterCategory(value ?? "");
            },
          ),

          OutlinedButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.refresh),
            label: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e.isEmpty ? "All" : e,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}