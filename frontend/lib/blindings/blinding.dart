import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/servicies/ai_chat_service.dart';
import 'package:frontend/servicies/ai_service.dart';
import 'package:frontend/servicies/audit_service.dart';
import 'package:frontend/servicies/comment_service.dart';
import 'package:frontend/servicies/notification_service.dart';
import 'package:frontend/servicies/profile_service.dart';
import 'package:frontend/servicies/ticket_service.dart';
import 'package:frontend/servicies/upload_service.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/ticket_controller.dart';
import '../servicies/dashboard_service.dart';

import 'package:frontend/controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ── Theme ─────────────────────────────────────────────────────────────
    Get.lazyPut<ThemeController>(
      () => ThemeController(),
      fenix: true,
    );

    // ── Navigation ────────────────────────────────────────────────────────
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );


    // ── Auth ──────────────────────────────────────────────────────────────
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );

    // ── Socket ────────────────────────────────────────────────────────────
    Get.lazyPut<SocketController>(
      () => SocketController(),
      fenix: true,
    );

    // ── Dashboard ─────────────────────────────────────────────────────────
    Get.lazyPut<AiService>(
      () => AiService(),
      fenix: true,
    );

    Get.lazyPut<UploadService>(
      () => UploadService(),
      fenix: true,
    );

    Get.lazyPut<DashboardService>(
      () => DashboardService(),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find<DashboardService>()),
      fenix: true,
    );

    // ── Ticket ────────────────────────────────────────────────────────────
    // TicketService now uses ApiService.instance.dio internally — no Dio arg.
    Get.lazyPut<TicketService>(
      () => TicketService(),
      fenix: true,
    );

    Get.lazyPut<TicketController>(
      () => TicketController(Get.find<TicketService>()),
      fenix: true,
    );

    // ── Upload ────────────────────────────────────────────────────────────
    Get.lazyPut<UploadController>(
      () => UploadController(Get.find<UploadService>()),
      fenix: true,
    );

    // ── AI ────────────────────────────────────────────────────────────────
    Get.lazyPut<AiController>(
      () => AiController(Get.find<AiService>()),
      fenix: true,
    );

    // ── Notification ──────────────────────────────────────────────────────
    // NotificationService now uses ApiService.instance.dio — no Dio arg.
    Get.lazyPut<NotificationService>(
      () => NotificationService(),
      fenix: true,
    );

    Get.lazyPut<NotificationController>(
      () => NotificationController(Get.find<NotificationService>()),
      fenix: true,
    );

    // ── Profile ───────────────────────────────────────────────────────────
    // ProfileService now uses ApiService.instance.dio — no Dio arg.
    Get.lazyPut<ProfileService>(
      () => ProfileService(),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<ProfileService>()),
      fenix: true,
    );

    // ── Comment ───────────────────────────────────────────────────────────
    // CommentService now uses ApiService.instance.dio — no Dio arg.
    Get.lazyPut<CommentService>(
      () => CommentService(),
      fenix: true,
    );

    Get.lazyPut<CommentController>(
      () => CommentController(Get.find<CommentService>()),
      fenix: true,
    );

    Get.lazyPut<ChatController>(
      () => ChatController(Get.find<CommentService>()),
      fenix: true,
    );

    // ── Audit ─────────────────────────────────────────────────────────────
    // AuditService now uses ApiService.instance.dio — no Dio arg.
    Get.lazyPut<AuditService>(
      () => AuditService(),
      fenix: true,
    );

    Get.lazyPut<AuditController>(
      () => AuditController(Get.find<AuditService>()),
      fenix: true,
    );

    // ── AI Chat ───────────────────────────────────────────────────────────
Get.lazyPut<AIChatService>(
  () => AIChatService(),
  fenix: true,
);

Get.lazyPut<AIChatController>(
  () => AIChatController(Get.find<AIChatService>()),
  fenix: true,
);
  }
}
