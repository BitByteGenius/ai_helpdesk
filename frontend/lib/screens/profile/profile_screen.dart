import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/widget/change_password_screen.dart';
import 'package:frontend/screens/profile/widget/edit_profile_screen.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_controller.dart';
import '../../../layouts/user_layout.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 750;

    return UserLayout(
      title: "Profile",
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = controller.profile.value;

        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined, size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  "Profile not found",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 40 : 24),
                  child: Column(
                    children: [
                      // --- PROFILE HEADER (AVATAR & BASICS) ---
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            backgroundImage: user.profileImage.isNotEmpty
                                ? NetworkImage(user.profileImage)
                                : null,
                            child: user.profileImage.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  )
                                : null,
                          ),
                          if (user.isVerified)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.cardColor, width: 3),
                              ),
                              child: const Icon(Icons.verified, size: 18, color: Colors.white),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),

                      // --- RESPONSIVE PROFILE INFO GRID ---
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildInfoCard(context, "Phone Number", user.phone, Icons.phone_outlined)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildInfoCard(context, "Account Role", user.role.toUpperCase(), Icons.badge_outlined)),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInfoCard(context, "Phone Number", user.phone, Icons.phone_outlined),
                                const SizedBox(height: 16),
                                _buildInfoCard(context, "Account Role", user.role.toUpperCase(), Icons.badge_outlined),
                              ],
                            ),
                      
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        "Verification Status",
                        user.isVerified ? "Verified Account" : "Unverified Account",
                        user.isVerified ? Icons.gpp_good_outlined : Icons.gpp_maybe_outlined,
                        iconColor: user.isVerified ? Colors.green : Colors.orange,
                      ),

                      const SizedBox(height: 40),
                      const Divider(),
                      const SizedBox(height: 24),

                      // --- ACCOUNT ACTIONS BAR ---
                      isDesktop
                          ? Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    label: const Text("Edit Profile"),
                                    onPressed: () => Get.to(() => const EditProfileScreen()),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: const Icon(Icons.lock_reset_outlined, size: 20),
                                    label: const Text("Change Password"),
                                    onPressed: () => Get.to(() => const ChangePasswordScreen()),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    label: const Text("Edit Profile"),
                                    onPressed: () => Get.to(() => const EditProfileScreen()),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: const Icon(Icons.lock_reset_outlined, size: 20),
                                    label: const Text("Change Password"),
                                    onPressed: () => Get.to(() => const ChangePasswordScreen()),
                                  ),
                                ),
                              ],
                            ),

                      const SizedBox(height: 16),
                      
                      // --- DESTRUCTIVE LOGOUT BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: theme.colorScheme.error,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 20),
                          label: const Text("Logout of Account", style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => Get.offAllNamed("/login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, {Color? iconColor}) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor ?? theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : "—",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}