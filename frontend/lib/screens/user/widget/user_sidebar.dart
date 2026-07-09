import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:get/get.dart';

/// A reactive, professional sidebar for the user section.
///
/// • Uses [ProfileController] for the user name/avatar.
/// • Uses [NotificationController] for the unread badge.
/// • Highlights the active route reactively via [GetX] routing observer.
/// • On mobile: closes the Drawer before navigating.
/// • On desktop: keeps sidebar permanently visible, no Drawer close needed.
/// • Logout: clears storage + disconnects socket + navigates to login.
class UserSidebar extends StatelessWidget {
  const UserSidebar({super.key});

  // ─── Navigation helper ────────────────────────────────────────────────────
  static void _navigate(BuildContext context, String route) {
    // Close Drawer on mobile before navigating to prevent stale overlay.
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      Navigator.of(context).pop();
      // Small delay so Drawer close animation completes before routing.
      Future.delayed(const Duration(milliseconds: 200), () {
        if (Get.currentRoute != route) {
          Get.offNamed(route);
        }
      });
    } else {
      if (Get.currentRoute != route) {
        Get.offNamed(route);
      }
    }
  }

  // ─── Logout ──────────────────────────────────────────────────────────────
  static Future<void> _logout(BuildContext context) async {
    // Close drawer if open on mobile.
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Disconnect socket.
    try {
      final socket = Get.find<SocketController>();
      socket.disconnect();
    } catch (_) {}

    // Clear auth state + storage.
    final auth = Get.find<AuthController>();
    await auth.logout();

    // Navigate to login, clearing the entire stack.
    Get.offAllNamed(AppRoutes.login);
  }

  // ─── Active route check ───────────────────────────────────────────────────
  /// Returns true when [route] matches the current navigation path,
  /// including sub-routes (e.g. /my-tickets/details still highlights myTickets).
  static bool _isActive(String currentRoute, String route) {
    if (route == AppRoutes.home) {
      return currentRoute == AppRoutes.home;
    }
    return currentRoute.startsWith(route);
  }

  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.find<ProfileController>();
    final notifCtrl = Get.find<NotificationController>();
    final navCtrl = Get.find<NavigationController>();

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Brand ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI Helpdesk',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // ── Profile Card ─────────────────────────────────────────────
            Obx(() {
              final profile = profileCtrl.profile.value;
              final auth = Get.find<AuthController>();
              final name = profile?.name.isNotEmpty == true
                  ? profile!.name
                  : (auth.user?.name.isNotEmpty == true
                      ? auth.user!.name
                      : 'User');
              final email = profile?.email ?? auth.user?.email ?? '';
              final avatarUrl = profile?.profileImage ?? '';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF6366F1),
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl.isEmpty
                          ? Text(
                              name.isNotEmpty
                                  ? name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // ── Navigation Label ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NAVIGATION',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Menu Items ───────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                children: [
                  Obx(() => _MenuItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    route: AppRoutes.home,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () => _navigate(context, AppRoutes.home),
                  )),
                  Obx(() => _MenuItem(
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Create Ticket',
                    route: AppRoutes.createTicket,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () =>
                        _navigate(context, AppRoutes.createTicket),
                  )),
                  Obx(() => _MenuItem(
                    icon: Icons.confirmation_number_rounded,
                    title: 'My Tickets',
                    route: AppRoutes.myTickets,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () => _navigate(context, AppRoutes.myTickets),
                  )),
                  Obx(() => _MenuItem(
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI Assistant',
                    route: AppRoutes.aiAssistant,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () =>
                        _navigate(context, AppRoutes.aiAssistant),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 16, 10, 6),
                    child: Text(
                      'ACCOUNT',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Obx(() => _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    route: AppRoutes.profile,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () => _navigate(context, AppRoutes.profile),
                  )),
                  Obx(() {
                    final unread = notifCtrl.unreadCount.value;
                    return _MenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      route: AppRoutes.notifications,
                      currentRoute: navCtrl.currentRoute.value,
                      badge: unread > 0 ? unread : null,
                      onTap: () =>
                          _navigate(context, AppRoutes.notifications),
                    );
                  }),
                  Obx(() => _MenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    route: AppRoutes.settings,
                    currentRoute: navCtrl.currentRoute.value,
                    onTap: () =>
                        _navigate(context, AppRoutes.settings),
                  )),
                ],
              ),
            ),

            // ── Divider ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                height: 1,
              ),
            ),

            const SizedBox(height: 6),

            // ── Logout ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: _LogoutTile(
                onTap: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private: Menu Item ──────────────────────────────────────────────────────

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;
  final VoidCallback onTap;
  final int? badge;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
    required this.onTap,
    this.badge,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovered = false;

  bool get _active => UserSidebar._isActive(widget.currentRoute, widget.route);

  @override
  Widget build(BuildContext context) {
    final active = _active;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF6366F1).withValues(alpha: 0.18)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active
                ? Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: active
                    ? const Color(0xFF818CF8)
                    : Colors.white.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.75),
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.badge! > 99
                        ? '99+'
                        : widget.badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (active)
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private: Logout Tile ────────────────────────────────────────────────────

class _LogoutTile extends StatefulWidget {
  final VoidCallback onTap;

  const _LogoutTile({required this.onTap});

  @override
  State<_LogoutTile> createState() => _LogoutTileState();
}

class _LogoutTileState extends State<_LogoutTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.red.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20,
                color: Colors.red.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
