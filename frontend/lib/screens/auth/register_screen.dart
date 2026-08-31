import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Get.find<AuthController>();

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Get.snackbar(
        "Registration Successful",
        "Your account has been created successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );

      Get.offAllNamed(
        auth.user?.isAdmin == true ? AppRoutes.dashboard : AppRoutes.home,
      );
    } else {
      Get.snackbar(
        "Registration Failed",
        auth.errorMessage.isNotEmpty
            ? auth.errorMessage
            : "An error occurred during registration.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    return Scaffold(
      backgroundColor: context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            constraints: BoxConstraints(maxWidth: isDesktop ? 500 : 440),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.border),
              boxShadow: context.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header Icon & Title ──
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: context.primarySubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: context.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            "Get started with your helpdesk portal",
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Full Name Input ──
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: context.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      hintText: "John Doe",
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your full name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Email Input ──
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: context.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Email address",
                      hintText: "you@example.com",
                      prefixIcon: Icon(Icons.email_outlined, size: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      final emailRegex = RegExp(
                        r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Phone Input ──
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: context.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "10-digit number",
                      prefixIcon: Icon(Icons.phone_outlined, size: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your phone number";
                      }
                      if (value.trim().length != 10) {
                        return "Phone number must be exactly 10 digits";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Password Input ──
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: context.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Min. 6 characters",
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: context.textMuted,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // ── Submit Button ──
                  GetBuilder<AuthController>(
                    builder: (auth) => FilledButton(
                      onPressed: auth.isLoading ? null : _register,
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Create Account"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Login Link ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
