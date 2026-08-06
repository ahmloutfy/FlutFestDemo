import 'package:flutfest/logic/controllers/create_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});

  // Get the controller instance
  CreateEventController get viewModel => Get.find<CreateEventController>();

  @override
  Widget build(BuildContext context) {
    // Wrap the WHOLE return with Obx because you are using .value multiple times inside
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Notification Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Push Notification Switch
        SwitchListTile(
          title: const Text("Push Notification"),
          subtitle: const Text("Receive a notification on your device"),
          value: viewModel.isPushEnabled.value, // Obx tracks this
          onChanged: (val) => viewModel.isPushEnabled.value = val,
          activeThumbColor: Theme.of(context).primaryColor,
        ),

        // Email Notification Switch
        SwitchListTile(
          title: const Text("Email Notification"),
          subtitle: const Text("Receive a reminder via email"),
          value: viewModel.isEmailEnabled.value, // Obx tracks this
          onChanged: (val) => viewModel.isEmailEnabled.value = val,
          activeThumbColor: Theme.of(context).primaryColor,
        ),

        const SizedBox(height: 10),

        const Text("Remind me:"),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: viewModel.selectedReminderMinutes.value, // Obx tracks this
              isExpanded: true,
              items: viewModel.reminderOptions.map((option) {
                return DropdownMenuItem<int>(
                  value: option['value'] as int,
                  child: Text(option['label'] as String),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  viewModel.selectedReminderMinutes.value = newValue;
                }
              },
            ),
          ),
        ),
      ],
    ));
  }
}