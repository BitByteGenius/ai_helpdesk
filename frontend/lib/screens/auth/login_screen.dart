import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

/// Single login screen that supports both User and Admin login modes.
/// Toggle between modes using the segmented tab bar.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final TabController _tabController;
  bool _obscurePassword = true;

  /// true  → Admin Login tab is active
  /// false → User Login tab is active
  bool get _isAdminMode => _tabController.index == 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Get.find<AuthController>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final bool success = _isAdminMode
        ? await auth.adminLogin(email: email, password: password)
        : await auth.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      Get.offAllNamed(
        auth.user?.isAdmin == true ? AppRoutes.dashboard : AppRoutes.home,
      );
      return;
    }

    if (!success) {
      Get.snackbar(
        "Login Failed",
        auth.errorMessage.isNotEmpty
            ? auth.errorMessage
            : "Invalid email or password",
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
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Container(
            constraints: BoxConstraints(maxWidth: isDesktop ? 860 : 440),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isDesktop
                ? Row(
                    children: [
                      // ── Left Brand Banner (Desktop) ──
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.support_agent_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 28),
                              const Text(
                                "AI-Powered\nHelpdesk",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                "Streamline ticketing, accelerate incident response, and harness AI copilot intelligence for your entire team.",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildFeaturePill(Icons.auto_awesome, "AI Copilot Analysis"),
                              const SizedBox(height: 10),
                              _buildFeaturePill(Icons.speed, "Fast SLA Resolution"),
                              const SizedBox(height: 10),
                              _buildFeaturePill(Icons.security, "Enterprise Security & Auditing"),
                            ],
                          ),
                        ),
                      ),
                      // ── Right Form (Desktop) ──
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: _buildForm(context),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(28),
                    child: _buildForm(context),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF818CF8)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Mobile Header ──
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _isAdminMode
                      ? Icons.admin_panel_settings_rounded
                      : Icons.support_agent_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    _isAdminMode
                        ? "Enter admin credentials"
                        : "Sign in to your client account",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── User / Admin Tab Switcher ──
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline_rounded, size: 16),
                      SizedBox(width: 6),
                      Text("Client"),
                    ],
                  ),
                ),
                Tab(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.admin_panel_settings_outlined, size: 16),
                      SizedBox(width: 6),
                      Text("Admin"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Email Input ──
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
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

          // ── Password Input ──
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "••••••••",
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: 24),

          // ── Submit Button ──
          GetBuilder<AuthController>(
            builder: (auth) => FilledButton(
              onPressed: auth.isLoading ? null : _submit,
              child: auth.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isAdminMode ? "Sign In as Admin" : "Sign In to Client",
                    ),
            ),
          ),

          // ── Register Link (User Mode) ──
          if (!_isAdminMode) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.register),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Register now",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
