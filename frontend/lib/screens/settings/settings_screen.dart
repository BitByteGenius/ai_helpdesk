// import 'package:flutter/material.dart';

// import '../../layouts/user_layout.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return UserLayout(
//       title: 'Settings',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Settings',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           const SizedBox(height: 8),

//           const Text(
//             'Manage your preferences and application settings.',
//             style: TextStyle(color: Colors.grey),
//           ),

//           const SizedBox(height: 30),

//           Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.notifications_outlined),
//                   title: const Text('Notifications'),
//                   subtitle: const Text('Manage notification preferences'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {},
//                 ),
//                 const Divider(height: 1),
//                 ListTile(
//                   leading: const Icon(Icons.language),
//                   title: const Text('Language'),
//                   subtitle: const Text('English'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {},
//                 ),
//                 const Divider(height: 1),
//                 ListTile(
//                   leading: const Icon(Icons.dark_mode_outlined),
//                   title: const Text('Theme'),
//                   subtitle: const Text('System default'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {},
//                 ),
//                 const Divider(height: 1),
//                 ListTile(
//                   leading: const Icon(Icons.info_outline),
//                   title: const Text('About'),
//                   subtitle: const Text('AI Helpdesk v1.0.0'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../../layouts/user_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return UserLayout(
      title: 'Settings',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER SECTION ---
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your preferences and application settings.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // --- PREFERENCES SECTION GROUP ---
                _buildSectionGroup(
                  context,
                  title: "Application Preferences",
                  tiles: [
                    _buildSettingsTile(
                      context,
                      leadingIcon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () {},
                    ),
                    _buildSettingsTile(
                      context,
                      leadingIcon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    _buildSettingsTile(
                      context,
                      leadingIcon: Icons.dark_mode_outlined,
                      title: 'Theme',
                      subtitle: 'System default',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- SYSTEM DETAILS GROUP ---
                _buildSectionGroup(
                  context,
                  title: "System & Info",
                  tiles: [
                    _buildSettingsTile(
                      context,
                      leadingIcon: Icons.info_outline_rounded,
                      title: 'About',
                      subtitle: 'AI Helpdesk v1.0.0',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionGroup(BuildContext context, {required String title, required List<Widget> tiles}) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 56,
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),
            itemBuilder: (context, index) => tiles[index],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          leadingIcon,
          size: 22,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
      ),
    );
  }
}