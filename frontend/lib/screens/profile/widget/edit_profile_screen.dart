import 'package:flutter/material.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Edit Profile',
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [

                      Obx(() {
  final profile = controller.profile.value;

  return CircleAvatar(
    radius: 55,
    backgroundImage: profile != null &&
            profile.profileImage.isNotEmpty
        ? NetworkImage(profile.profileImage)
        : null,
    child: profile == null ||
            profile.profileImage.isEmpty
        ? const Icon(
            Icons.person,
            size: 50,
          )
        : null,
  );
}),

                      const SizedBox(height: 15),

                      OutlinedButton.icon(
  onPressed: () async {
    await controller.uploadProfileImage();
  },
  icon: const Icon(Icons.camera_alt),
  label: const Text("Change Photo"),
),

                      const SizedBox(height: 30),

                      TextField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: controller.phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),

                      const SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          icon: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),

                          label: const Text("Save Changes"),

                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  await controller.updateProfile();

                                  Get.back();
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
