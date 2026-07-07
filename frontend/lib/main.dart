import 'package:flutter/material.dart';
import 'package:frontend/blindings/blindingh.dart';
import 'package:frontend/core/routes/app_routes.dart';
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
    );
  }
}
