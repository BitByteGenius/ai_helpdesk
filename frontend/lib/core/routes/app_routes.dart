import 'package:frontend/models/upload_model.dart';
import 'package:frontend/screens/ai/ai_assistant_screen.dart';
import 'package:frontend/screens/audit/audit_screen.dart';
import 'package:frontend/screens/notification/notification_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/screens/settings/settings_screen.dart';
import 'package:frontend/screens/tickets/admin_d/admin_ticket_details_screen.dart';
import 'package:frontend/screens/tickets/ticket_list_screen.dart';
import 'package:frontend/screens/tickets/user_d/create_ticket_screen.dart';
import 'package:frontend/screens/tickets/user_d/user_ticket_details_screen.dart';
import 'package:frontend/screens/uploads/upload_screen.dart';
import 'package:frontend/screens/uploads/widget/upload_preview.dart';
import 'package:frontend/screens/user/widget/my_tickets_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
  static const uploadPreview = '/upload-preview';
  static const audit = '/audit';

  static const userTicketDetails = "/user/ticket-details";
  static const adminTicketDetails = "/admin/ticket-details";
}

class AppRouter {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      transition: Transition.noTransition,
    ),

    // ── User ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.home,
      page: () => const UserDashboard(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.createTicket,
      page: () => const CreateTicketScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.myTickets,
      page: () => const MyTicketsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.userTicketDetails,
      page: () {
        final args = Get.arguments;
        if (args == null || args is! String) {
          return const Scaffold(
            body: Center(
              child: Text("Invalid Ticket ID"),
            ),
          );
        }
        return UserTicketDetailsScreen(
          ticketId: args,
        );
      },
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.adminTicketDetails,
      page: () {
        final args = Get.arguments;
        if (args == null || args is! String) {
          return const Scaffold(
            body: Center(
              child: Text("Invalid Ticket ID"),
            ),
          );
        }
        return AdminTicketDetailsScreen(
          ticketId: args,
        );
      },
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AICopilotScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.noTransition,
    ),

    // ── Admin ─────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const AdminDashboard(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.tickets,
      page: () => const TicketListScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.uploads,
      page: () => const UploadScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.uploadPreview,
      page: () {
        final args = Get.arguments;
        if (args is UploadModel) {
          return UploadPreview(upload: args);
        }
        return const Scaffold(body: Center(child: Text("No file provided")));
      },
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.audit,
      page: () => const AuditScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.adminAiAssistant,
      page: () => const AdminAiScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.adminSettings,
      page: () => const AdminSettingsScreen(),
      transition: Transition.noTransition,
    ),
  ];
}

