import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: context.textMuted,
        ),
        onPressed: onToggle,
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
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.border),
              ),
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Security Credentials",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: -0.3,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ensure your account is using a strong password with at least 6 characters.",
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: hideCurrent,
                      style: TextStyle(color: context.textPrimary, fontSize: 14),
                      decoration: inputDecoration(
                        context: context,
                        label: "Current Password",
                        icon: Icons.lock_outline_rounded,
                        obscure: hideCurrent,
                        onToggle: () {
                          setState(() {
                            hideCurrent = !hideCurrent;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter current password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: hideNew,
                      style: TextStyle(color: context.textPrimary, fontSize: 14),
                      decoration: inputDecoration(
                        context: context,
                        label: "New Password",
                        icon: Icons.lock_rounded,
                        obscure: hideNew,
                        onToggle: () {
                          setState(() {
                            hideNew = !hideNew;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Minimum 6 characters required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: hideConfirm,
                      style: TextStyle(color: context.textPrimary, fontSize: 14),
                      decoration: inputDecoration(
                        context: context,
                        label: "Confirm New Password",
                        icon: Icons.lock_reset_rounded,
                        obscure: hideConfirm,
                        onToggle: () {
                          setState(() {
                            hideConfirm = !hideConfirm;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(
                        () => FilledButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  await controller.changePassword(
                                    currentPassword: currentPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  );

                                  if (mounted) {
                                    Get.back();
                                  }
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update Password",
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
    );
  }
}
