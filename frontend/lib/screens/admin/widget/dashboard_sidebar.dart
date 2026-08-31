import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/sidebar_menu.dart';
import 'package:get/get.dart';

class DashboardSidebar extends StatelessWidget {
  final bool compact;

  const DashboardSidebar({
    super.key,
    this.compact = false,
  });

  final List<SidebarMenu> menus = const [
    SidebarMenu(
      title: "Dashboard",
      icon: Icons.dashboard_rounded,
      route: AppRoutes.dashboard,
    ),
    SidebarMenu(
      title: "Tickets",
      icon: Icons.confirmation_number_rounded,
      route: AppRoutes.tickets,
    ),
    SidebarMenu(
      title: "File Manager",
      icon: Icons.folder_shared_rounded,
      route: AppRoutes.uploads,
    ),
    SidebarMenu(
      title: "Audit Logs",
      icon: Icons.history_rounded,
      route: AppRoutes.audit,
    ),
    SidebarMenu(
      title: "AI Copilot",
      icon: Icons.auto_awesome_rounded,
      route: AppRoutes.adminAiAssistant,
    ),
    SidebarMenu(
      title: "Settings",
      icon: Icons.settings_rounded,
      route: AppRoutes.adminSettings,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<NavigationController>();

    return Container(
      width: compact ? 80 : 260,
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
              padding: EdgeInsets.fromLTRB(
                compact ? 12 : 20,
                20,
                compact ? 12 : 20,
                16,
              ),
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
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AI Helpdesk",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "ADMIN CONSOLE",
                              style: TextStyle(
                                color: Color(0xFF818CF8),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFF1E293B), height: 1),
            ),

            const SizedBox(height: 12),

            if (!compact)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "MANAGEMENT",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            // ── Menu List ──
            Expanded(
              child: Obx(() {
                final selectedRoute = navCtrl.currentRoute.value;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  itemCount: menus.length,
                  itemBuilder: (_, index) {
                    final menu = menus[index];
                    final selected = selectedRoute == menu.route ||
                        (menu.route == AppRoutes.tickets &&
                            (selectedRoute.contains('/ticket') || selectedRoute == AppRoutes.adminTicketDetails)) ||
                        (menu.route == AppRoutes.uploads && selectedRoute.contains('/upload'));

                    return _AdminSidebarItem(
                      menu: menu,
                      selected: selected,
                      compact: compact,
                      onTap: () {
                        final scaffold = Scaffold.maybeOf(context);
                        if (scaffold != null && scaffold.isDrawerOpen) {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 200), () {
                            if (Get.currentRoute != menu.route) {
                              Get.offNamed(menu.route);
                            }
                          });
                        } else {
                          if (Get.currentRoute != menu.route) {
                            Get.offNamed(menu.route);
                          }
                        }
                      },
                    );

                  },
                );
              }),
            ),

            // ── User Profile Footer ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFF1E293B), height: 1),
            ),

            GetBuilder<AuthController>(
              builder: (authCtrl) {
                final user = authCtrl.user;
                final displayName =
                    user?.name.isNotEmpty == true ? user!.name : "Administrator";
                final email = user?.email ?? "admin@helpdesk.com";

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: EdgeInsets.all(compact ? 6 : 10),
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
                        backgroundImage: user?.profileImage.isNotEmpty == true
                            ? NetworkImage(user!.profileImage)
                            : null,
                        child: user == null || user.profileImage.isEmpty
                            ? Text(
                                displayName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              )
                            : null,
                      ),
                      if (!compact) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSidebarItem extends StatefulWidget {
  final SidebarMenu menu;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _AdminSidebarItem({
    required this.menu,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  @override
  State<_AdminSidebarItem> createState() => _AdminSidebarItemState();
}

class _AdminSidebarItemState extends State<_AdminSidebarItem> {
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
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 12 : 14,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.primary.withValues(alpha: 0.18)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment:
                widget.compact ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                widget.menu.icon,
                color: widget.selected
                    ? const Color(0xFF818CF8)
                    : _hovered
                        ? Colors.white
                        : const Color(0xFF94A3B8),
                size: 20,
              ),
              if (!widget.compact) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.menu.title,
                    style: TextStyle(
                      color: widget.selected
                          ? Colors.white
                          : _hovered
                              ? Colors.white
                              : const Color(0xFFCBD5E1),
                      fontWeight:
                          widget.selected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (widget.selected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF818CF8),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

