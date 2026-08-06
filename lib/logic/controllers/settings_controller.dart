import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum ThemeOption { light, dark, system }

class SettingsController extends GetxController {
  ThemeMode getThemeMode() {
    switch (themeOption.value) {
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  var themeOption = ThemeOption.system.obs;

  // Notifications enabled or not
  var notificationsEnabled = false.obs;

  // Location access enabled or not
  var locationAccessEnabled = false.obs;

  var defaultReminderMinutes = 10.obs;
  var defaultEnablePush = true.obs;
  var defaultEnableEmail = false.obs;
  var defaultEnableCalendar = false.obs;

  final List<Map<String, dynamic>> reminderOptions = [
    {'label': 'At time of event', 'value': 0},
    {'label': '10 minutes before', 'value': 10},
    {'label': '30 minutes before', 'value': 30},
    {'label': '1 hour before', 'value': 60},
    {'label': '1 day before', 'value': 1440},
  ];

  void changeTheme(ThemeOption option) {
    themeOption.value = option;
    switch (option) {
      case ThemeOption.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case ThemeOption.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case ThemeOption.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    showCustomSnackBar(
      value ? 'Notifications enabled' : 'Notifications disabled',
    );
  }

  void toggleLocationAccess(bool value) {
    locationAccessEnabled.value = value;
    showCustomSnackBar(
      value ? 'Location access allowed' : 'Location access denied',
    );
  }


  void changeDefaultReminder(int value) {
    defaultReminderMinutes.value = value;

    final option = reminderOptions.firstWhere((opt) => opt['value'] == value, orElse: () => {'label': '$value minutes'});
    showCustomSnackBar('Default reminder set to: ${option['label']}');
  }

  void toggleDefaultPush(bool value) {
    defaultEnablePush.value = value;
    showCustomSnackBar(
      value ? 'Default push notifications enabled' : 'Default push notifications disabled',
    );
  }

  void toggleDefaultEmail(bool value) {
    defaultEnableEmail.value = value;
    showCustomSnackBar(
      value ? 'Default email reminders enabled' : 'Default email reminders disabled',
    );
  }

  void toggleDefaultCalendar(bool value) {
    defaultEnableCalendar.value = value;
    showCustomSnackBar(
      value ? 'Calendar synchronization enabled' : 'Calendar synchronization disabled',
    );
  }
}