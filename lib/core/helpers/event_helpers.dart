import 'dart:convert';

import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/core/services/notification_service.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/navigation_controller.dart';
import 'package:flutfest/logic/models/create_event_view_model.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/widgets/buttons/dialog_action_button.dart';
import 'package:flutfest/widgets/dialogs/custom_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/controllers/user_controller.dart';

String formatEventDate(EventModel event) {
  final start = event.startDate;
  final end = event.endDate;

  if (start == null || end == null) {
    return 'No date available';
  }

  final sameDay = start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;

  if (sameDay) {
    return DateFormat('d MMM yyyy – hh:mm a').format(start);
  }

  return '${DateFormat('d MMM yyyy – hh:mm a').format(start)}'
      ' - ${DateFormat('d MMM yyyy – hh:mm a').format(end)}';
}

void inviteFriends(EventModel event) {
  final formattedDate =
      DateFormat('d MMM yyyy – hh:mm a').format(event.startDate!);
  final text = 'Join me at this event: ${event.title} '
      'on $formattedDate at ${event.location ?? "Unknown location"}';
  SharePlus.instance.share(ShareParams(
    text: text,
    subject: 'Event Invitation',
  ));
}

void submitEventForm({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required CreateEventViewModel viewModel,
  required EventController eventController,
}) async {
  if (!formKey.currentState!.validate()) {
    showCustomSnackBar('Please fill out all required fields');
    return;
  }

  if (viewModel.pickedImage.value == null) {
    viewModel.imageError.value = 'Please select an image';
    return;
  }

  final userController = Get.find<UserController>();
  final eventController = Get.find<EventController>();

  final range = viewModel.selectedDateRange.value;
  if (range == null) {
    showCustomSnackBar('Please select a date range');
    return;
  }

  final imageBytes = await viewModel.pickedImage.value!.readAsBytes();
  final imageDataUri = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

  final newEvent = EventModel(
    eventId: eventController.eventUuid.v4(),
    title: viewModel.titleController.text,
    location: viewModel.locationController.text,
    description: viewModel.descriptionController.text,
    startDate: range.start,
    endDate: range.end,
    image: imageDataUri,
    creatorId: userController.currentUserId.value,
    joinedUserIds: [],
    remindMeBefore: viewModel.selectedReminderMinutes.value,
    enablePush: viewModel.isPushEnabled.value,
    enableEmail: viewModel.isEmailEnabled.value,
  );

  eventController.addEvent(newEvent);
  await eventController.saveEventsToPrefs(eventController.events);

  final navigationController = Get.find<NavigationController>();

  if (newEvent.enablePush) {
    await NotificationService.scheduleEventNotification(
      newEvent,
      newEvent.remindMeBefore,
    );
  }

  if (!context.mounted) return;

  showDialog(
      context: context,
      builder: (_) {
        final title = newEvent.title ?? viewModel.titleController.text;
        final location = newEvent.location ?? viewModel.locationController.text;
        final date =
            '${DateFormat.yMMMMd().format(range.start)} - ${DateFormat.yMMMMd().format(range.end)}';

        return CustomAlertDialog(
          title: 'Event Created',
          content: 'Your event was successfully created!',
          actions: [
            DialogActionButton(
              label: 'Share Event',
              onPressed: () {
                Get.back();

                SharePlus.instance.share(ShareParams(
                  text: 'Check out this event: $title - $location on $date',
                ));
              },
            ),
            const SizedBox(height: 12),
            DialogActionButton(
              label: 'Create Another',
              onPressed: () {
                Get.back();
                viewModel.resetForm();
              },
            ),
            const SizedBox(height: 12),
            DialogActionButton(
              label: 'Invite Friends',
              onPressed: () {
                Get.back();

                inviteFriends(newEvent);
              },
            ),
            const SizedBox(height: 12),
            DialogActionButton(
              label: 'Browse Events',
              onPressed: () {
                Get.offAllNamed(Routes.home);
                navigationController.setIndex(0);
              },
            ),
            const SizedBox(height: 12),
            DialogActionButton(
              label: 'Edit Event',
              onPressed: () {
                Get.back();
                Get.toNamed(Routes.createEvent, arguments: newEvent);
              },
            ),
          ],
        );
      });
}
