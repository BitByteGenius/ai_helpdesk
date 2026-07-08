import 'package:flutter/material.dart';
import 'package:frontend/models/sidebar_menu.dart';
import 'package:get/get.dart';


class DashboardSidebar extends StatelessWidget {
  DashboardSidebar({
    super.key,
    this.compact = false,
  });

  final RxInt selectedIndex = 0.obs;
  final bool compact;

  final List<SidebarMenu> menus = const [
    SidebarMenu(
      title: "Dashboard",
      icon: Icons.dashboard_rounded,
      route: "/dashboard",
    ),
    SidebarMenu(
      title: "Tickets",
      icon: Icons.confirmation_number_rounded,
      route: "/tickets",
    ),
    SidebarMenu(
      title: "Users",
      icon: Icons.people_alt_rounded,
      route: "/users",
    ),
    SidebarMenu(
      title: "Analytics",
      icon: Icons.analytics_rounded,
      route: "/analytics",
    ),
    SidebarMenu(
      title: "AI Assistant",
      icon: Icons.smart_toy_rounded,
      route: "/ai",
    ),
    SidebarMenu(
      title: "Settings",
      icon: Icons.settings_rounded,
      route: "/settings",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool collapsed = compact;

    return Container(
      width: collapsed ? 84 : 280,
      color: const Color(0xff1E293B),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (!collapsed)
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

            const SizedBox(height: 40),

            Expanded(
              child: Obx(
                () {
                  final currentIndex = selectedIndex.value;

                  return ListView.builder(
                    itemCount: menus.length,
                    itemBuilder: (_, index) {
                      final menu = menus[index];
                      final selected = currentIndex == index;

                      return InkWell(
                        onTap: () {
                          selectedIndex.value = index;

                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }

                          if (menu.route == "/login") {
                            Get.offAllNamed(menu.route);
                          }
                        },
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withOpacity(.14)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                menu.icon,
                                color: Colors.white,
                                size: 22,
                              ),
                              if (!collapsed) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    menu.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(color: Colors.white24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: collapsed
                    ? null
                    : const Text(
                        "Administrator",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                subtitle: collapsed
                    ? null
                    : const Text(
                        "admin@gmail.com",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
                title: collapsed
                    ? null
                    : const Text(
                        "Logout",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                onTap: () {
                  Get.offAllNamed("/login");
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
