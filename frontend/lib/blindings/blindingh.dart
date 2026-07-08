import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../servicies/dashboard_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );

    Get.lazyPut<DashboardService>(
      () => DashboardService(),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      fenix: true,
    );
  }
}