import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/screens/audit/widget/audit_details_dialog.dart';
import 'package:get/get.dart';


class AuditTable extends GetView<AuditController> {
  const AuditTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(

          columns: const [

            DataColumn(
              label: Text("User"),
            ),

            DataColumn(
              label: Text("Action"),
            ),

            DataColumn(
              label: Text("Entity"),
            ),

            DataColumn(
              label: Text("Description"),
            ),

            DataColumn(
              label: Text("Time"),
            ),

            DataColumn(
              label: Text("View"),
            ),
          ],

          rows: controller.audits.map((audit) {

            return DataRow(

              cells: [

                DataCell(
                  Text(audit.user.name),
                ),

                DataCell(
                  Text(audit.action),
                ),

                DataCell(
                  Text(audit.entity),
                ),

                DataCell(
                  SizedBox(
                    width: 250,
                    child: Text(
                      audit.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                DataCell(
                  Text(
                    audit.createdAt.toString(),
                  ),
                ),

                DataCell(
                  IconButton(

                    icon: const Icon(Icons.visibility),

                    onPressed: () async {

                      await controller.openAudit(
                        audit.id,
                      );

                      Get.dialog(
                        const AuditDetailsDialog(),
                      );

                    },
                  ),
                ),
              ],
            );

          }).toList(),
        ),
      );
    });
  }
}