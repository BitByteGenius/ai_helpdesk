import 'package:flutter/material.dart';
import 'package:frontend/screens/user/widget/user_sidebar.dart';

/// Shared layout for all user-facing screens.
///
/// • Desktop (≥ 1100 px): permanent sidebar + no AppBar.
/// • Mobile / Tablet (< 1100 px): Drawer-based sidebar + AppBar with
///   hamburger menu so the user can open the Drawer.
class UserLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const UserLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width >= 1100;

    return Scaffold(
      appBar: desktop
          ? null
          : AppBar(
              title: Text(title),
              centerTitle: false,
              // Hamburger icon — opens the Drawer automatically via Scaffold.
            ),

      drawer: desktop
          ? null
          : const Drawer(
              child: UserSidebar(),
            ),

      body: SafeArea(
        child: Row(
          children: [
            if (desktop) const UserSidebar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}