import 'package:frontend/screens/admin/admin_dashboard.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';
import 'package:get/get.dart';



class AppRoutes {
  AppRoutes._();

  static const splash = "/";
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";
  static const admin = "/admin";
  static const profile = "/profile";
  static const settings = "/settings";
}

class AppRouter {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),

    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),

    GetPage(name: AppRoutes.home, page: () => const UserDashboard()),



    GetPage(name: AppRoutes.admin, page: () => const AdminDashboard()),


  ];
}
