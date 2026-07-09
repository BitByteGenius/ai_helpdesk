import 'package:frontend/controllers/ai_chat_controller.dart';
import 'package:frontend/controllers/ai_controller.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:frontend/controllers/notification_controller.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/servicies/ai_chat_service.dart';

import 'package:frontend/servicies/audit_service.dart';
import 'package:frontend/servicies/comment_service.dart';
import 'package:frontend/servicies/notification_service.dart';
import 'package:frontend/servicies/profile_service.dart';
import 'package:frontend/servicies/ticket_service.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/ticket_controller.dart';

import '../servicies/dashboard_service.dart';

import 'package:dio/dio.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    /// Dio
    Get.lazyPut<Dio>(
      () => Dio(),
      fenix: true,
    );

    /// Auth
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );

    /// Dashboard
    Get.lazyPut<DashboardService>(
      () => DashboardService(),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      fenix: true,
    );

    /// Ticket
    Get.lazyPut<TicketService>(
      () => TicketService(Get.find<Dio>()),
      fenix: true,
    );

    Get.lazyPut<TicketController>(
      () => TicketController(Get.find<TicketService>()),
      fenix: true,
    );

    Get.lazyPut<UploadController>(
  () => UploadController(),
  fenix: true,
);

Get.lazyPut<AiController>(
  () => AiController(),
  fenix: true,
);

Get.lazyPut<SocketController>(
  () => SocketController(),
  fenix: true,
);


Get.lazyPut<NotificationService>(
  () => NotificationService(Get.find()),
  fenix: true,
);

Get.lazyPut<NotificationController>(
  () => NotificationController(
    Get.find<NotificationService>(),
  ),
  fenix: true,
);
Get.lazyPut<ProfileService>(
  () => ProfileService(Get.find()),
  fenix: true,
);

Get.lazyPut<ProfileController>(
  () => ProfileController(
    Get.find<ProfileService>(),
  ),
  fenix: true,
);
Get.lazyPut<CommentService>(
  () => CommentService(Get.find()),
  fenix: true,
);

Get.lazyPut<CommentController>(
  () => CommentController(
    Get.find<CommentService>(),
  ),
  fenix: true,
);



Get.lazyPut<AuditService>(
  () => AuditService(Get.find()),
  fenix: true,
);

Get.lazyPut<AuditController>(
  () => AuditController(
    Get.find<AuditService>(),
  ),
  fenix: true,
);

Get.lazyPut<NavigationController>(
  () => NavigationController(),
  fenix: true,
);

Get.lazyPut<AIChatService>(
  () => AIChatService(Get.find<Dio>()),
  fenix: true,
);

Get.lazyPut<AIChatController>(
  () => AIChatController(
    Get.find<AIChatService>(),
  ),
  fenix: true,
);


  }
}
