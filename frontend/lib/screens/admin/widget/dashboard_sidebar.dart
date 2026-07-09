import 'package:flutter/material.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/models/sidebar_menu.dart';
import 'package:get/get.dart';


class DashboardSidebar extends StatelessWidget {
  DashboardSidebar({
    super.key,
    this.compact = false,
  });

  final bool compact;

  final RxInt selectedIndex = 0.obs;

  final List<SidebarMenu> menus = [
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
      title: "Users",
      icon: Icons.people_alt_rounded,
      route: AppRoutes.users,
    ),
    SidebarMenu(
      title: "Analytics",
      icon: Icons.analytics_rounded,
      route: AppRoutes.analytics,
    ),
    SidebarMenu(
      title: "Settings",
      icon: Icons.settings_rounded,
      route: AppRoutes.adminSettings,
    ),
    
    SidebarMenu(
      icon: Icons.history,
      title: "Audit Logs",
      route: AppRoutes.audit,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<NavigationController>();
    return Container(
      width: compact ? 85 : 260,
      color: const Color(0xff1E293B),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (!compact)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AI Helpdesk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 34,
              ),

            const SizedBox(height: 35),

            Expanded(
              child: ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (_, index) {
                    final menu = menus[index];

                    final selected = navCtrl.currentRoute.value == menu.route;

                    return InkWell(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }

                        /// Navigate
                        Get.offNamed(menu.route);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(14),
                          color: selected
                              ? Colors.white12
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              menu.icon,
                              color: Colors.white,
                            ),

                            if (!compact) ...[
                              const SizedBox(width: 16),

                              Expanded(
                                child: Text(
                                  menu.title,
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),

            const Divider(
              color: Colors.white24,
            ),

            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: compact
                    ? null
                    : const Text(
                        "Administrator",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                subtitle: compact
                    ? null
                    : const Text(
                        "admin@gmail.com",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
              ),
            ),

            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: compact
                    ? null
                    : const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                onTap: () {
                  Get.offAllNamed(
                    AppRoutes.login,
                  );
                },
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
