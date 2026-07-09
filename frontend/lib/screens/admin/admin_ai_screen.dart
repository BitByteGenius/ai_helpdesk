import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';

class AdminAiScreen extends StatelessWidget {
  const AdminAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'AI Assistant',
      child: const Center(
        child: Text(
          'Admin AI Assistant',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
