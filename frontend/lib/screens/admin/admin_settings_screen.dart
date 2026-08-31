import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/theme_controller.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _emailAlerts = true;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final themeCtrl = Get.find<ThemeController>();


    return AdminLayout(
      title: "Settings",
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Preferences",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Manage global workspace configurations, theme modes, and notification triggers.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Admin Profile Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth.user?.name ?? "Administrator",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  auth.user?.email ?? "admin@enterprise.internal",
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("SUPER ADMIN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Theme selector
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.palette_outlined, size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                "Theme Appearance",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Obx(() {
                            return Text(
                              "Current theme: ${themeCtrl.themeModeName}",
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            );
                          }),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _buildThemeOption(
                                  mode: ThemeMode.system,
                                  title: "System",
                                  icon: Icons.brightness_auto_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildThemeOption(
                                  mode: ThemeMode.light,
                                  title: "Light",
                                  icon: Icons.light_mode_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildThemeOption(
                                  mode: ThemeMode.dark,
                                  title: "Dark",
                                  icon: Icons.dark_mode_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Notification toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: SwitchListTile(
                        value: _emailAlerts,
                        onChanged: (val) => setState(() => _emailAlerts = val),
                        title: const Text("Ticket Activity Alerts", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary)),
                        subtitle: const Text("Receive instant notifications on ticket assignments and escalation triggers", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notifications_outlined, size: 20, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // System version info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("AI Helpdesk Enterprise", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary)),
                                SizedBox(height: 2),
                                Text("Production Build v1.0.0 — Flutter Web & Desktop", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text("Logout of Admin Console", style: TextStyle(fontWeight: FontWeight.w700)),
                        onPressed: () async {
                          await Get.find<AuthController>().logout();
                          Get.offAllNamed(AppRoutes.login);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption({
    required ThemeMode mode,
    required String title,
    required IconData icon,
  }) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      final isSelected = themeCtrl.themeMode.value == mode;

      return InkWell(
        onTap: () => themeCtrl.setThemeMode(mode),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySubtle : AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

