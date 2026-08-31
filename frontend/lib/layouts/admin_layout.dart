import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/screens/admin/widget/dashboard_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width >= 1024;

    return Scaffold(
      backgroundColor: context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: desktop
          ? null
          : AppBar(
              backgroundColor: context.cardBg,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: context.border),
              ),
              actions: actions,
            ),
      drawer: desktop
          ? null
          : const Drawer(
              backgroundColor: Color(0xFF0F172A),
              surfaceTintColor: Colors.transparent,
              child: DashboardSidebar(compact: false),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desktop) const DashboardSidebar(compact: false),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
