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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.darkCard : AppColors.card;
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final primarySubtle = isDark ? const Color(0xFF312E81) : AppColors.primarySubtle;

    return AdminLayout(
      title: "Settings",
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;
          final horizontalPadding = constraints.maxWidth >= 1200
              ? 32.0
              : isNarrow
                  ? 16.0
                  : 24.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 36),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Admin Preferences",
                      style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: textPrimary,
                          ) ??
                          TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: textPrimary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Manage global workspace configurations, theme modes, and notification triggers.",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Admin Profile Card
                    Container(
                      padding: EdgeInsets.all(isNarrow ? 14 : 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primarySubtle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.admin_panel_settings_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth.user?.name ?? "Administrator",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  auth.user?.email ?? "admin@enterprise.internal",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primarySubtle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "SUPER ADMIN",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF818CF8) : AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Theme selector
                    Container(
                      padding: EdgeInsets.all(isNarrow ? 16 : 20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primarySubtle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.palette_outlined,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Theme Appearance",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.5,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(() {
                                      return Text(
                                        "Active: ${themeCtrl.themeModeName}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildThemeOption(
                                    themeCtrl: themeCtrl,
                                    mode: ThemeMode.system,
                                    title: "System",
                                    icon: Icons.brightness_auto_rounded,
                                    isDark: isDark,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildThemeOption(
                                    themeCtrl: themeCtrl,
                                    mode: ThemeMode.light,
                                    title: "Light",
                                    icon: Icons.light_mode_rounded,
                                    isDark: isDark,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildThemeOption(
                                    themeCtrl: themeCtrl,
                                    mode: ThemeMode.dark,
                                    title: "Dark",
                                    icon: Icons.dark_mode_rounded,
                                    isDark: isDark,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notification toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: SwitchListTile(
                        value: _emailAlerts,
                        activeThumbColor: primaryColor,
                        activeTrackColor: primarySubtle,
                        onChanged: (val) => setState(() => _emailAlerts = val),
                        title: Text(
                          "Ticket Activity Alerts",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Receive instant notifications on ticket assignments and escalation triggers",
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primarySubtle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // System version info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI Helpdesk Enterprise",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Production Build v1.0.0 — Flutter Web, Desktop & Mobile",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          "Logout of Admin Console",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
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
    required ThemeController themeCtrl,
    required ThemeMode mode,
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = themeCtrl.themeMode.value == mode;

    final selectedBg = isDark
        ? const Color(0xFF312E81).withValues(alpha: 0.6)
        : AppColors.primarySubtle;
    final unselectedBg = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.5)
        : AppColors.surfaceSubtle;

    final selectedBorder = isDark ? AppColors.primaryLight : AppColors.primary;
    final unselectedBorder = isDark ? AppColors.borderDark : AppColors.border;

    final selectedIconColor = isDark ? const Color(0xFF818CF8) : AppColors.primary;
    final unselectedIconColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;

    final selectedTextColor = isDark ? const Color(0xFF818CF8) : AppColors.primary;
    final unselectedTextColor = isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;

    return InkWell(
      onTap: () => themeCtrl.setThemeMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? selectedIconColor : unselectedIconColor,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedTextColor : unselectedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}