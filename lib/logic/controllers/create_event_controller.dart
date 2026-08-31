// 📁 lib/logic/controllers/create_event_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutfest/logic/controllers/settings_controller.dart';

class CreateEventController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedDate = Rxn<DateTime>();
  final pickedImage = Rxn<XFile>();

  var isPushEnabled = true.obs;
  var isEmailEnabled = false.obs;
  var isCalendarEnabled = false.obs;
  var selectedReminderMinutes = 10.obs;

  final List<Map<String, dynamic>> reminderOptions = [
    {'label': 'At time of event', 'value': 0},
    {'label': '10 minutes before', 'value': 10},
    {'label': '30 minutes before', 'value': 30},
    {'label': '1 hour before', 'value': 60},
    {'label': '1 day before', 'value': 1440},
  ];

  @override
  void onInit() async {
    // Call super.onInit() at the beginning as a best practice
    super.onInit();

    // Fetch customized default values from the user settings
    try {
      final settingsController = Get.find<SettingsController>();

      isPushEnabled.value = settingsController.defaultEnablePush.value;
      isEmailEnabled.value = settingsController.defaultEnableEmail.value;
      isCalendarEnabled.value = settingsController.defaultEnableCalendar.value;
      selectedReminderMinutes.value =
          settingsController.defaultReminderMinutes.value;
    } catch (e) {
      // Fallback in case SettingsController is not registered or initialized yet
      if (kDebugMode) {
        print("SettingsController not initialized yet, using local defaults.");
      }
    }

    // Request notification permissions manually for Android 13+ and iOS when screen opens
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      if (kDebugMode) {
        print("Error requesting notification permissions: $e");
      }
    }
  }

  // Pick an image from the device gallery
  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage.value = pickedFile;
    }
  }

  // Display date picker themed dynamically based on current brightness
  void pickDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlueAccent,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Reset all form inputs and re-assign default options
  void resetForm() {
    titleController.clear();
    locationController.clear();
    descriptionController.clear();
    selectedDate.value = null;
    pickedImage.value = null;

    isPushEnabled.value = true;
    isEmailEnabled.value = false;
    isCalendarEnabled.value = false;
    selectedReminderMinutes.value = 10;
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
