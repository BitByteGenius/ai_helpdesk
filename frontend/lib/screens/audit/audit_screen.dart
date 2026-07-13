import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/audit/widget/audit_filter.dart';
import 'package:frontend/screens/audit/widget/audit_table.dart';



class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Audit Logs',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const AuditFilter(),

            const SizedBox(height: 20),

            const Expanded(
              child: AuditTable(),
            ),
          ],
        ),
      ),
    );
  }
}
