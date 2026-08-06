import 'package:flutfest/core/helpers/attendance_helper.dart';
import 'package:flutfest/core/helpers/event_helpers.dart';
import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/user_controller.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/theme.dart';
import 'package:flutfest/widgets/buttons/add_to_calendar_button.dart';
import 'package:flutfest/widgets/buttons/attending_button.dart';
import 'package:flutfest/widgets/buttons/favorite_button.dart';
import 'package:flutfest/widgets/buttons/primary_button.dart';
import 'package:flutfest/widgets/buttons/share_event_button.dart';
import 'package:flutfest/widgets/custom_appbar.dart';
import 'package:flutfest/widgets/images/event_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/dialogs/custom_success_dialog.dart';
import '../../widgets/dialogs/dialog_action_button.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isAttended = false;
  late EventModel currentEvent;
  final eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    currentEvent = widget.event;
    // Read attendance state from controller at start
    isAttended = eventController.isUserAttending(
      currentEvent.eventId,
      Get.find<UserController>().currentUserId.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isCreator =
        currentEvent.creatorId == userController.currentUserId.value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        context,
        currentEvent.title ?? 'Event details',
        textStyle: const TextStyle(fontSize: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event-${currentEvent.eventId}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: EventImage(event: currentEvent, imageHeight: 300),
                ),
              ),
            ),
            Gutter(),
            Text(
              currentEvent.title ?? '',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Gutter(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                Gutter(),
                Expanded(
                    child: Text(
                  formatEventDate(currentEvent),
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.visible,
                )),
              ],
            ),
            Gutter(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                Gutter(),
                if (currentEvent.location != null)
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        try {
                          final url =
                              'https://maps.google.com/?q=${Uri.encodeComponent(currentEvent.location!)}';
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          Get.snackbar('Error', 'Could not open map: $e',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Image.network(
                        'https://maps.googleapis.com/maps/api/staticmap?center=${Uri.encodeComponent(currentEvent.location!)}&zoom=13&size=300x150&markers=${Uri.encodeComponent(currentEvent.location!)}&key=AIzaSyAFjAwgUvo6QWMI9Z2OFuIlHq7kLeg9I9k',
                        width: 150,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
            Gutter(),
            Text('Description',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Gutter(),
            Text(currentEvent.description ?? '',
                style: theme.textTheme.bodyMedium),
            Gutter(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final attending = eventController.isUserAttending(
                    currentEvent.eventId,
                    userController.currentUserId.value,
                  );
                  return AttendingButton(
                    label: attending ? 'Cancel Attending' : 'Attend Now',
                    icon: attending ? Icons.cancel : Icons.event_available,
                    backgroundColor:
                        attending ? Colors.red : AppTheme.getColorForTheme(
                          context: context,
                          lightModeColor: AppTheme.lightEventRSVPButtonColor,
                          darkModeColor: AppTheme.darkEventRSVPButtonColor,
                        ),
                    onPressed: () async {
                      await handleAttendance(currentEvent.eventId);
                    },
                  );
                }),
                Gutter(),
                AddToCalendarButton(event: currentEvent),
                Gutter(),
                FavoriteButton(widget: widget),
                Gutter(),
                ShareButton(
                  widget: widget,
                  formattedDate: formatEventDate(currentEvent),
                ),
                Gutter(),
                if (isCreator) ...[
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Edit Event',
                    onPressed: () async {
                      final updatedEvent = await Get.toNamed('/edit-event',
                          arguments: currentEvent);
                      if (updatedEvent != null && updatedEvent is EventModel) {
                        setState(() {
                          currentEvent = updatedEvent;
                        });
                      }
                    },
                    icon: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Delete Event',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => CustomAlertDialog(
                          title: 'Confirm Delete',
                          content:
                              'Are you sure you want to delete this event?',
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DialogActionButton(
                                    label: 'Cancel',
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false)),
                                const SizedBox(width: 12),
                                DialogActionButton(
                                  label: 'Delete',
                                  onPressed: () {
                                    eventController
                                        .deleteEvent(currentEvent.eventId);
                                    Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        Get.back();
                        showCustomSnackBar('Event deleted successfully.');
                      }
                    },
                    icon:
                        Icon(Icons.delete, color: theme.colorScheme.onPrimary),
                    backgroundColor: Colors.red,
                  ),
                ],
              ],
            ),
            Gutter(),
          ],
        ),
      ),
    );
  }
}
