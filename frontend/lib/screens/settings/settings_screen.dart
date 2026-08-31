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
          final isNarrow = constraints.maxWidth < 600;
          final horizontalPadding = constraints.maxWidth >= 1200
              ? 32.0
              : isNarrow
                  ? 16.0
                  : 24.0;

          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          final cardBg = isDark ? AppColors.darkCard : AppColors.card;
          final borderColor = isDark ? AppColors.borderDark : AppColors.border;
          final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;
          final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textSecondary;
          final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
          final primarySubtle = isDark ? const Color(0xFF312E81) : AppColors.primarySubtle;
          final dividerColor = isDark ? AppColors.borderDark : AppColors.borderLight;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 36),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Header
                    Text(
                      'Settings & Preferences',
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
                      'Manage your workspace preferences, appearance theme, and application options.',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- APPEARANCE THEME SELECTOR CARD ---
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
                                      "Appearance Theme",
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

                          // 3-Way Segmented Selector
                          Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildThemeOption(
                                    context: context,
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
                                    context: context,
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
                                    context: context,
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
                    const SizedBox(height: 24),

                    // // --- APPLICATION PREFERENCES GROUP ---
                    // _buildSectionGroup(
                    //   context: context,
                    //   title: "Application Preferences",
                    //   cardBg: cardBg,
                    //   borderColor: borderColor,
                    //   dividerColor: dividerColor,
                    //   primaryColor: primaryColor,
                    //   tiles: [
                    //     _buildSettingsTile(
                    //       context: context,
                    //       leadingIcon: Icons.notifications_outlined,
                    //       title: 'Notifications',
                    //       subtitle: 'Receive real-time push alerts and ticket status change updates',
                    //       isDark: isDark,
                    //       onTap: () {},
                    //     ),
                    //     _buildSettingsTile(
                    //       context: context,
                    //       leadingIcon: Icons.language_rounded,
                    //       title: 'Language',
                    //       subtitle: 'English (United States)',
                    //       isDark: isDark,
                    //       onTap: () {},
                    //     ),
                    //     Obx(() => _buildSettingsTile(
                    //           context: context,
                    //           leadingIcon: Icons.dark_mode_outlined,
                    //           title: 'Theme Preference',
                    //           subtitle: '${themeCtrl.themeModeName} Mode Active',
                    //           isDark: isDark,
                    //           onTap: () => _showThemeDialog(context, themeCtrl),
                    //         )),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),

                    // --- SYSTEM DETAILS GROUP ---
                    _buildSectionGroup(
                      context: context,
                      title: "System & About",
                      cardBg: cardBg,
                      borderColor: borderColor,
                      dividerColor: dividerColor,
                      primaryColor: primaryColor,
                      tiles: [
                        _buildSettingsTile(
                          context: context,
                          leadingIcon: Icons.info_outline_rounded,
                          title: 'About AI Helpdesk',
                          subtitle: 'Enterprise Ticket Management & Copilot System v1.0.0',
                          isDark: isDark,
                          onTap: () {},
                        ),
                        _buildSettingsTile(
                          context: context,
                          leadingIcon: Icons.privacy_tip_outlined,
                          title: 'Privacy & Security',
                          subtitle: 'Review privacy policies and data protection compliance',
                          isDark: isDark,
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
    required BuildContext context,
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

  // void _showThemeDialog(BuildContext context, ThemeController themeCtrl) {
  //   final theme = Theme.of(context);
  //   final isDark = theme.brightness == Brightness.dark;
  //   final cardBg = isDark ? AppColors.darkCard : Colors.white;
  //   final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;

  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       backgroundColor: cardBg,
  //       surfaceTintColor: Colors.transparent,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //         side: BorderSide(
  //           color: isDark ? AppColors.borderDark : AppColors.border,
  //         ),
  //       ),
  //       title: Text(
  //         "Select Theme Mode",
  //         style: TextStyle(
  //           color: textPrimary,
  //           fontWeight: FontWeight.w700,
  //           fontSize: 18,
  //         ),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           _buildThemeOption(
  //             context: context,
  //             themeCtrl: themeCtrl,
  //             mode: ThemeMode.system,
  //             title: "System Default",
  //             icon: Icons.brightness_auto_rounded,
  //             isDark: isDark,
  //           ),
  //           const SizedBox(height: 10),
  //           _buildThemeOption(
  //             context: context,
  //             themeCtrl: themeCtrl,
  //             mode: ThemeMode.light,
  //             title: "Light Mode",
  //             icon: Icons.light_mode_rounded,
  //             isDark: isDark,
  //           ),
  //           const SizedBox(height: 10),
  //           _buildThemeOption(
  //             context: context,
  //             themeCtrl: themeCtrl,
  //             mode: ThemeMode.dark,
  //             title: "Dark Mode",
  //             icon: Icons.dark_mode_rounded,
  //             isDark: isDark,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text(
  //             "Close",
  //             style: TextStyle(
  //               color: isDark ? AppColors.primaryLight : AppColors.primary,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSectionGroup({
    required BuildContext context,
    required String title,
    required Color cardBg,
    required Color borderColor,
    required Color dividerColor,
    required Color primaryColor,
    required List<Widget> tiles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: primaryColor,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 56,
              color: dividerColor,
            ),
            itemBuilder: (context, index) => tiles[index],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final primarySubtle = isDark ? const Color(0xFF312E81) : AppColors.primarySubtle;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primarySubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          leadingIcon,
          size: 20,
          color: primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
          color: textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: textSecondary,
          height: 1.3,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark ? const Color(0xFF64748B) : AppColors.textMuted,
        size: 20,
      ),
    );
  }
}