import 'package:flutter/material.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final ProfileController controller =
      Get.find<ProfileController>();

  final _formKey = GlobalKey<FormState>();

  final currentPasswordController =
      TextEditingController();

  final newPasswordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool hideCurrent = true;
  bool hideNew = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        icon: Icon(
          obscure
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      title: 'Change Password',
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        controller:
                            currentPasswordController,
                        obscureText: hideCurrent,
                        decoration: inputDecoration(
                          label:
                              "Current Password",
                          icon: Icons.lock,
                          obscure: hideCurrent,
                          onToggle: () {
                            setState(() {
                              hideCurrent =
                                  !hideCurrent;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Enter current password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller:
                            newPasswordController,
                        obscureText: hideNew,
                        decoration: inputDecoration(
                          label: "New Password",
                          icon: Icons.lock_outline,
                          obscure: hideNew,
                          onToggle: () {
                            setState(() {
                              hideNew = !hideNew;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller:
                            confirmPasswordController,
                        obscureText: hideConfirm,
                        decoration: inputDecoration(
                          label:
                              "Confirm Password",
                          icon: Icons.lock_reset,
                          obscure: hideConfirm,
                          onToggle: () {
                            setState(() {
                              hideConfirm =
                                  !hideConfirm;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value !=
                              newPasswordController
                                  .text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                controller
                                        .isLoading
                                        .value
                                    ? null
                                    : () async {
                                        if (!_formKey
                                            .currentState!
                                            .validate()) {
                                          return;
                                        }

                                        await controller
                                            .changePassword(
                                          currentPassword:
                                              currentPasswordController
                                                  .text,
                                          newPassword:
                                              newPasswordController
                                                  .text,
                                        );

                                        if (mounted) {
                                          Get.back();
                                        }
                                      },
                            child:
                                controller
                                        .isLoading
                                        .value
                                    ? const CircularProgressIndicator(
                                        color:
                                            Colors.white,
                                      )
                                    : const Text(
                                        "Change Password",
                                      ),
                          ),
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
