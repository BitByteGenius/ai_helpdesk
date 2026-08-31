import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/screens/profile/widget/change_password_screen.dart';
import 'package:frontend/screens/profile/widget/edit_profile_screen.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../layouts/user_layout.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: "My Profile",
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = controller.profile.value;

        if (user == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined, size: 64, color: AppColors.error),
                SizedBox(height: 16),
                Text(
                  "Profile not found",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 750;
            final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: EdgeInsets.all(isDesktop ? 36 : 20),
                    child: Column(
                      children: [
                        // --- PROFILE HEADER (AVATAR & BASICS) ---
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: AppColors.primarySubtle,
                              backgroundImage: user.profileImage.isNotEmpty ? NetworkImage(user.profileImage) : null,
                              child: user.profileImage.isEmpty
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 54,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                            if (user.isVerified)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                ),
                                child: const Icon(Icons.check, size: 14, color: Colors.white),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            letterSpacing: -0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: AppColors.borderLight),
                        const SizedBox(height: 20),

                        // --- RESPONSIVE PROFILE INFO GRID ---
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildInfoCard("Phone Number", user.phone, Icons.phone_outlined)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInfoCard("Account Role", user.role.toUpperCase(), Icons.badge_outlined)),
                            ],
                          )
                        else ...[
                          _buildInfoCard("Phone Number", user.phone, Icons.phone_outlined),
                          const SizedBox(height: 12),
                          _buildInfoCard("Account Role", user.role.toUpperCase(), Icons.badge_outlined),
                        ],

                        const SizedBox(height: 12),
                        _buildInfoCard(
                          "Verification Status",
                          user.isVerified ? "Verified Account" : "Unverified Account",
                          user.isVerified ? Icons.verified_user_outlined : Icons.gpp_maybe_outlined,
                          iconColor: user.isVerified ? AppColors.success : AppColors.warning,
                        ),

                        const SizedBox(height: 28),
                        const Divider(height: 1, color: AppColors.borderLight),
                        const SizedBox(height: 24),

                        // --- ACCOUNT ACTIONS BAR ---
                        if (isDesktop)
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  label: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w700)),
                                  onPressed: () => Get.to(() => const EditProfileScreen()),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: AppColors.border),
                                  ),
                                  icon: const Icon(Icons.lock_reset_rounded, size: 18),
                                  label: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.w600)),
                                  onPressed: () => Get.to(() => const ChangePasswordScreen()),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w700)),
                              onPressed: () => Get.to(() => const EditProfileScreen()),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              icon: const Icon(Icons.lock_reset_rounded, size: 18),
                              label: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.w600)),
                              onPressed: () => Get.to(() => const ChangePasswordScreen()),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // --- LOGOUT BUTTON ---
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: AppColors.error,
                            ),
                            icon: const Icon(Icons.logout_rounded, size: 18),
                            label: const Text("Logout of Account", style: TextStyle(fontWeight: FontWeight.w700)),
                            onPressed: () => Get.offAllNamed(AppRoutes.login),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, {Color? iconColor}) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : "—",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
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