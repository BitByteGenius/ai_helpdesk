import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
  static bool _isActive(String currentRoute, String route) {
    if (route == AppRoutes.home) {
      return currentRoute == AppRoutes.home;
    }
    if (route == AppRoutes.myTickets) {
      return currentRoute == AppRoutes.myTickets ||
          currentRoute == AppRoutes.userTicketDetails ||
          currentRoute == AppRoutes.ticketDetails;
    }
    if (route == AppRoutes.profile) {
      return currentRoute.startsWith('/profile');
    }
    return currentRoute == route || (route.isNotEmpty && currentRoute.startsWith(route));
  }


  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.find<ProfileController>();
    final notifCtrl = Get.find<NotificationController>();
    final navCtrl = Get.find<NavigationController>();

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        border: Border(
          right: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Brand Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Helpdesk',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          'Client Portal',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFF1E293B), height: 1),
            ),

            const SizedBox(height: 12),

            // ── Navigation Label ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MAIN MENU',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // ── Menu Items ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 16, 10, 6),
                    child: Text(
                      'ACCOUNT',
                      style: TextStyle(
                        color: Color(0xFF64748B),
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

            // ── Divider ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFF1E293B), height: 1),
            ),

            // ── Profile Card & Logout ──
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
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl.isEmpty
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                      tooltip: 'Logout',
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              );
            }),
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
                ? AppColors.primary.withValues(alpha: 0.18)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
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
                    : _hovered
                        ? Colors.white
                        : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : _hovered
                            ? Colors.white
                            : const Color(0xFFCBD5E1),
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
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF818CF8),
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

