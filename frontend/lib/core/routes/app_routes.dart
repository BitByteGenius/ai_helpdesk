import 'package:frontend/screens/ai/ai_assistant_screen.dart';
import 'package:frontend/screens/audit/audit_screen.dart';
import 'package:frontend/screens/notification/notification_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/screens/settings/settings_screen.dart';
import 'package:frontend/screens/tickets/ticket_details_screen.dart';
import 'package:frontend/screens/tickets/ticket_list_screen.dart';
import 'package:frontend/screens/tickets/user_d/create_ticket_screen.dart';
import 'package:frontend/screens/uploads/upload_screen.dart';
import 'package:frontend/screens/user/widget/my_tickets_screen.dart';
import 'package:get/get.dart';

import 'package:frontend/screens/admin/admin_dashboard.dart';
import 'package:frontend/screens/admin/admin_ai_screen.dart';
import 'package:frontend/screens/admin/admin_settings_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/register_screen.dart';
import 'package:frontend/screens/user/home_screen.dart';
import 'package:frontend/screens/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  // User
  static const home = '/home';
  static const createTicket = '/create-ticket';
  static const myTickets = '/my-tickets';
  static const ticketDetails = '/ticket-details';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const aiAssistant = '/ai';
  static const settings = '/settings';

  // Admin
  static const dashboard = '/dashboard';
  static const tickets = '/tickets';
  static const users = '/users';
  static const analytics = '/analytics';
  static const adminAiAssistant = '/admin/ai';
  static const adminSettings = '/admin/settings';
  static const uploads = '/uploads';
  static const audit = '/audit';
}

class AppRouter {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),

    // ── User ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.home,
      page: () => const UserDashboard(),
    ),

    GetPage(
      name: AppRoutes.createTicket,
      page: () => const CreateTicketScreen(),
    ),

    GetPage(
      name: AppRoutes.myTickets,
      page: () => const MyTicketsScreen(),
    ),

    GetPage(
      name: AppRoutes.ticketDetails,
      page: () {
        final id = Get.arguments as String;
        return TicketDetailsScreen(ticketId: id);
      },
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
    ),

    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AICopilotScreen(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),

    // ── Admin ─────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () =>  const AdminDashboard(),
    ),

    GetPage(
      name: AppRoutes.tickets,
      page: () => const TicketListScreen(),
    ),

    GetPage(
      name: AppRoutes.uploads,
      page: () => const UploadScreen(),
    ),

    GetPage(
      name: AppRoutes.audit,
      page: () => const AuditScreen(),
    ),

    GetPage(
      name: AppRoutes.adminAiAssistant,
      page: () => const AdminAiScreen(),
    ),

    GetPage(
      name: AppRoutes.adminSettings,
      page: () => const AdminSettingsScreen(),
    ),
  ];
}
