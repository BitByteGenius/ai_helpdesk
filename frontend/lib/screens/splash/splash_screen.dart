import 'package:flutter/material.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(AppConfig.splashDuration);

    if (!mounted) return;

    final auth = Get.find<AuthController>();
    final loggedIn = await auth.autoLogin();

    if (!mounted) return;

    if (loggedIn) {
      Get.offAllNamed(
        auth.user?.isAdmin == true ? AppRoutes.dashboard : AppRoutes.home,
      );
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'AI Desk Management System',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
