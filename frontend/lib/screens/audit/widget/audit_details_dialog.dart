import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:get/get.dart';


class AuditDetailsDialog extends GetView<AuditController> {
  const AuditDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 700,
        child: Obx(() {
          final audit = controller.selectedAudit.value;

          if (audit == null) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    const Icon(Icons.history),

                    const SizedBox(width: 10),

                    Text(
                      "Audit Details",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),

                const Divider(),

                _item("User", audit.user.name),

                _item("Email", audit.user.email),

                _item("Role", audit.user.role),

                _item("Action", audit.action),

                _item("Entity", audit.entity),

                _item("Description", audit.description),

                _item("IP Address", audit.ipAddress),

                _item("Browser", audit.userAgent),

                _item(
                  "Created",
                  audit.createdAt.toString(),
                ),

                const SizedBox(height: 25),

                if (audit.oldData != null) ...[
                  const Text(
                    "Old Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      audit.oldData.toString(),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                if (audit.newData != null) ...[
                  const Text(
                    "New Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      audit.newData.toString(),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _item(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}