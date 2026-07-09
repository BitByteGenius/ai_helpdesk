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
          return const Center(
            child: Text("Profile not found"),
          );
        }

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            user.profileImage.isNotEmpty
                                ? NetworkImage(user.profileImage)
                                : null,
                        child: user.profileImage.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 55,
                              )
                            : null,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Divider(),

                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone"),
                        subtitle: Text(user.phone),
                      ),

                      ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text("Role"),
                        subtitle: Text(user.role),
                      ),

                      ListTile(
                        leading: Icon(
                          user.isVerified
                              ? Icons.verified
                              : Icons.error_outline,
                          color: user.isVerified
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: const Text("Verification"),
                        subtitle: Text(
                          user.isVerified
                              ? "Verified"
                              : "Not Verified",
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                          onPressed: () {
                            Get.to(
                              () => const EditProfileScreen(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.lock),
                          label:
                              const Text("Change Password"),
                          onPressed: () {
                            Get.to(
                              () =>
                                  const ChangePasswordScreen(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Get.offAllNamed("/login");
                          },
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
}