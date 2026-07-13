import 'package:flutter/material.dart';
import 'package:frontend/screens/admin/widget/dashboard_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width >= 1200;

    return Scaffold(
      appBar: desktop
          ? null
          : AppBar(
              title: Text(title),
              centerTitle: false,
            ),
      drawer: desktop
          ? null
          : Drawer(
              child: DashboardSidebar(compact: false),
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (desktop) DashboardSidebar(compact: false),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
