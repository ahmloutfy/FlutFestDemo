import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutfest/logic/controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ListView(
            children: [
              const Text(
                'Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RadioGroup<ThemeOption>(
                groupValue: controller.themeOption.value,
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.changeTheme(newValue);
                  }
                },
                child: Column(
                  children: ThemeOption.values.map((option) {
                    return RadioListTile<ThemeOption>(
                      title: Text(option.name.capitalizeFirst ?? option.name),
                      value: option,
                    );
                  }).toList(),
                ),
              ),

              const Divider(height: 32),

              const Text(
                'General Permissions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
              ),
              SwitchListTile(
                title: const Text('Allow Location Access'),
                value: controller.locationAccessEnabled.value,
                onChanged: controller.toggleLocationAccess,
              ),

              const Divider(height: 32),

              const Text(
                'Default Event Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text("Default Reminder Time:", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.defaultReminderMinutes.value,
                    isExpanded: true,
                    items: controller.reminderOptions.map((option) {
                      return DropdownMenuItem<int>(
                        value: option['value'] as int,
                        child: Text(option['label'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.changeDefaultReminder(newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Default Notification Methods:", style: TextStyle(fontSize: 14, color: Colors.grey)),

              SwitchListTile(
                title: const Text('Push Notification'),
                subtitle: const Text('Receive device notification alert'),
                value: controller.defaultEnablePush.value,
                onChanged: controller.toggleDefaultPush,
              ),
              SwitchListTile(
                title: const Text('Email Alert'),
                subtitle: const Text('Receive event reminder email'),
                value: controller.defaultEnableEmail.value,
                onChanged: controller.toggleDefaultEmail,
              ),
              SwitchListTile(
                title: const Text('Sync with Calendar'),
                subtitle: const Text('Add events automatically to device calendar'),
                value: controller.defaultEnableCalendar.value,
                onChanged: controller.toggleDefaultCalendar,
              ),

              const Divider(height: 32),

              const Text(
                'About App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new, size: 20),
                onTap: () async {
                  final Uri url = Uri.parse('https://ahmloutfy.github.io/FlutFestDemo/privacy_policy.html');
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    Get.snackbar('Error', 'Could not open privacy policy');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.1.0+7'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
