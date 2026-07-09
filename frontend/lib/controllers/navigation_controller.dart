import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxString currentRoute = ''.obs;

  void updateRoute(String? route) {
    if (route == null || route.isEmpty) return;
    currentRoute.value = route;
  }
}
