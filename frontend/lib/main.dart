import 'package:flutter/material.dart';
import 'package:frontend/blindings/blinding.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/controllers/navigation_controller.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRouter.pages,
      routingCallback: (routing) {
        if (Get.isRegistered<NavigationController>()) {
          Get.find<NavigationController>().updateRoute(routing?.current);
        }
      },
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const _NotFoundScreen(),
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
