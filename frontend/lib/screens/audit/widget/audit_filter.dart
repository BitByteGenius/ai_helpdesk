import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:get/get.dart';


class AuditFilter extends GetView<AuditController> {
  const AuditFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [

            SizedBox(
              width: 220,
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  initialValue: controller.selectedAction.value.isEmpty
                      ? null
                      : controller.selectedAction.value,

                  decoration: const InputDecoration(
                    labelText: "Action",
                    border: OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "LOGIN",
                      child: Text("LOGIN"),
                    ),

                    DropdownMenuItem(
                      value: "REGISTER",
                      child: Text("REGISTER"),
                    ),

                    DropdownMenuItem(
                      value: "CREATE",
                      child: Text("CREATE"),
                    ),

                    DropdownMenuItem(
                      value: "UPDATE",
                      child: Text("UPDATE"),
                    ),

                    DropdownMenuItem(
                      value: "DELETE",
                      child: Text("DELETE"),
                    ),

                    DropdownMenuItem(
                      value: "ASSIGN",
                      child: Text("ASSIGN"),
                    ),

                    DropdownMenuItem(
                      value: "STATUS_CHANGE",
                      child: Text("STATUS CHANGE"),
                    ),

                    DropdownMenuItem(
                      value: "COMMENT",
                      child: Text("COMMENT"),
                    ),

                    DropdownMenuItem(
                      value: "UPLOAD",
                      child: Text("UPLOAD"),
                    ),

                    DropdownMenuItem(
                      value: "AI_ANALYSIS",
                      child: Text("AI ANALYSIS"),
                    ),
                  ],

                  onChanged: (value) {
                    controller.filterAction(
                      value ?? "",
                    );
                  },
                );
              }),
            ),

            SizedBox(
              width: 220,
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  initialValue: controller.selectedEntity.value.isEmpty
                      ? null
                      : controller.selectedEntity.value,

                  decoration: const InputDecoration(
                    labelText: "Entity",
                    border: OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "AUTH",
                      child: Text("AUTH"),
                    ),

                    DropdownMenuItem(
                      value: "TICKET",
                      child: Text("TICKET"),
                    ),

                    DropdownMenuItem(
                      value: "PROFILE",
                      child: Text("PROFILE"),
                    ),

                    DropdownMenuItem(
                      value: "COMMENT",
                      child: Text("COMMENT"),
                    ),

                    DropdownMenuItem(
                      value: "UPLOAD",
                      child: Text("UPLOAD"),
                    ),

                    DropdownMenuItem(
                      value: "AI",
                      child: Text("AI"),
                    ),
                  ],

                  onChanged: (value) {
                    controller.filterEntity(
                      value ?? "",
                    );
                  },
                );
              }),
            ),

            ElevatedButton.icon(
              onPressed: controller.clearFilters,

              icon: const Icon(Icons.refresh),

              label: const Text("Clear"),
            ),
          ],
        ),
      ),
    );
  }
}