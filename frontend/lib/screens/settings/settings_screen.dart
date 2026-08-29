import 'package:flutter/material.dart';
import 'package:frontend/controllers/theme_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../layouts/user_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return UserLayout(
      title: 'Settings',
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
                      'Settings & Preferences',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage your workspace preferences, theme appearance, and notification options.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- APPEARANCE THEME SELECTOR CARD ---
                    Container(
                      padding: const EdgeInsets.all(20),
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
                                "Appearance Theme",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
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
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildThemeOption(
                                  themeCtrl: themeCtrl,
                                  mode: ThemeMode.system,
                                  title: "System",
                                  icon: Icons.brightness_auto_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildThemeOption(
                                  themeCtrl: themeCtrl,
                                  mode: ThemeMode.light,
                                  title: "Light",
                                  icon: Icons.light_mode_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildThemeOption(
                                  themeCtrl: themeCtrl,
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
                    const SizedBox(height: 24),

                    // --- PREFERENCES GROUP ---
                    _buildSectionGroup(
                      title: "Application Preferences",
                      tiles: [
                        _buildSettingsTile(
                          leadingIcon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Receive real-time push alerts and ticket status change updates',
                          onTap: () {},
                        ),
                        _buildSettingsTile(
                          leadingIcon: Icons.language_rounded,
                          title: 'Language',
                          subtitle: 'English (United States)',
                          onTap: () {},
                        ),
                        Obx(() => _buildSettingsTile(
                              leadingIcon: Icons.dark_mode_outlined,
                              title: 'Theme Preference',
                              subtitle: '${themeCtrl.themeModeName} Mode Active',
                              onTap: () => _showThemeDialog(context, themeCtrl),
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- SYSTEM DETAILS GROUP ---
                    _buildSectionGroup(
                      title: "System & About",
                      tiles: [
                        _buildSettingsTile(
                          leadingIcon: Icons.info_outline_rounded,
                          title: 'About AI Helpdesk',
                          subtitle: 'Enterprise Ticket Management & Copilot System v1.0.0',
                          onTap: () {},
                        ),
                        _buildSettingsTile(
                          leadingIcon: Icons.privacy_tip_outlined,
                          title: 'Privacy & Security',
                          subtitle: 'Review privacy policies and data protection compliance',
                          onTap: () {},
                        ),
                      ],
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
  }) {
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

  void _showThemeDialog(BuildContext context, ThemeController themeCtrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Theme Mode"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(themeCtrl: themeCtrl, mode: ThemeMode.system, title: "System Default", icon: Icons.brightness_auto_rounded),
            const SizedBox(height: 10),
            _buildThemeOption(themeCtrl: themeCtrl, mode: ThemeMode.light, title: "Light Mode", icon: Icons.light_mode_rounded),
            const SizedBox(height: 10),
            _buildThemeOption(themeCtrl: themeCtrl, mode: ThemeMode.dark, title: "Dark Mode", icon: Icons.dark_mode_rounded),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionGroup({required String title, required List<Widget> tiles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 56,
              color: AppColors.borderLight,
            ),
            itemBuilder: (context, index) => tiles[index],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primarySubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          leadingIcon,
          size: 20,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
        size: 20,
      ),
    );
  }
}
