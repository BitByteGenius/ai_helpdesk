import 'package:frontend/models/darshboard_model.dart';
import 'package:frontend/servicies/dashboard_service.dart';
import 'package:get/get.dart';


class DashboardController extends GetxController {
  final DashboardService _service = Get.find();

  final RxBool isLoading = false.obs;

  final RxBool hasError = false.obs;

  final RxString errorMessage = "".obs;

  final Rxn<DashboardModel> dashboard = Rxn<DashboardModel>();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      dashboard.value = await _service.getDashboard();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }
}