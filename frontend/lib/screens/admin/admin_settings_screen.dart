import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Settings',
      child: const Center(
        child: Text(
          'Admin Settings',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
