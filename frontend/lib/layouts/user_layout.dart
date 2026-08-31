import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/screens/notification/widget/notification_badge.dart';
import 'package:frontend/screens/user/widget/user_sidebar.dart';

/// Shared layout for all user-facing screens.
///
/// • Desktop (≥ 1024 px): permanent sidebar + no AppBar.
/// • Mobile / Tablet (< 1024 px): Drawer-based sidebar + AppBar with
///   hamburger menu and notifications badge.
class UserLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? actions;

  const UserLayout({
    super.key,
    required this.child,
    required this.title,
    this.padding,
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
              actions: actions ??
                  const [
                    NotificationBadge(),
                    SizedBox(width: 8),
                  ],
            ),
      drawer: desktop
          ? null
          : const Drawer(
              backgroundColor: Color(0xFF0F172A),
              surfaceTintColor: Colors.transparent,
              child: UserSidebar(),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desktop) const UserSidebar(),
            Expanded(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}