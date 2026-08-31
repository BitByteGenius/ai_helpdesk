import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Edit Profile',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.border),
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Obx(() {
                        final profile = controller.profile.value;

                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: context.primarySubtle,
                              backgroundImage: profile != null && profile.profileImage.isNotEmpty
                                  ? NetworkImage(profile.profileImage)
                                  : null,
                              child: profile == null || profile.profileImage.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 50,
                                      color: context.primaryColor,
                                    )
                                  : null,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.border),
                        ),
                        onPressed: () async {
                          await controller.uploadProfileImage();
                        },
                        icon: const Icon(Icons.camera_alt_outlined, size: 16),
                        label: const Text("Change Photo", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: controller.nameController,
                        style: TextStyle(color: context.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.emailController,
                        style: TextStyle(color: context.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(Icons.mail_outline_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.phoneController,
                        style: TextStyle(color: context.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: Icon(Icons.phone_outlined, size: 18),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Obx(
                          () => FilledButton.icon(
                            icon: controller.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.check_rounded, size: 18),
                            label: const Text("Save Profile Changes", style: TextStyle(fontWeight: FontWeight.w700)),
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    await controller.updateProfile();
                                    Get.back();
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
