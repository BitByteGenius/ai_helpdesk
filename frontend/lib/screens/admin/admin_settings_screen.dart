import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:get/get.dart';

import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/controllers/auth_controller.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState
    extends State<AdminSettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return AdminLayout(
      title: "Settings",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              "Settings",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              "Manage your admin preferences.",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.admin_panel_settings),
                ),
                //title: const Text("Admin"),
                title: Text(
  auth.user?.name ?? "Administrator",
),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text("Theme"),
                    subtitle: const Text(
                      "Choose application appearance",
                    ),
                  ),

                  RadioListTile(
                    value: ThemeMode.system,
                    groupValue: _themeMode,
                    title: const Text("System"),
                    onChanged: (value) {
                      setState(() {
                        _themeMode = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    value: ThemeMode.light,
                    groupValue: _themeMode,
                    title: const Text("Light"),
                    onChanged: (value) {
                      setState(() {
                        _themeMode = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    value: ThemeMode.dark,
                    groupValue: _themeMode,
                    title: const Text("Dark"),
                    onChanged: (value) {
                      setState(() {
                        _themeMode = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text(
                  "Notifications",
                ),
                subtitle: const Text(
                  "Receive ticket and system alerts",
                ),
                secondary:
                    const Icon(Icons.notifications),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text("Version"),
                subtitle: const Text("1.0.0"),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
  width: double.infinity,
  height: 52,
  child: FilledButton.icon(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.red,
    ),
    icon: const Icon(Icons.logout),
    label: const Text("Logout"),
    // Changed from onTap to onPressed
    onPressed: () async {
      await Get.find<AuthController>().logout();
      Get.offAllNamed(AppRoutes.login);
    },
  ),
)
          ],
        ),
      ),
    );
  }
}