import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themePrefKey = "app_theme_mode";

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            themeMode.value = ThemeMode.light;
            Get.changeThemeMode(ThemeMode.light);
            break;
          case 'dark':
            themeMode.value = ThemeMode.dark;
            Get.changeThemeMode(ThemeMode.dark);
            break;
          default:
            themeMode.value = ThemeMode.system;
            Get.changeThemeMode(ThemeMode.system);
            break;
        }
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      switch (mode) {
        case ThemeMode.light:
          await prefs.setString(_themePrefKey, 'light');
          break;
        case ThemeMode.dark:
          await prefs.setString(_themePrefKey, 'dark');
          break;
        case ThemeMode.system:
          await prefs.setString(_themePrefKey, 'system');
          break;
      }
    } catch (_) {}
  }

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  String get themeModeName {
    switch (themeMode.value) {
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "System default";
    }
  }
}
