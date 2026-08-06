// lib/views/home/components/event_card.dart
import 'package:flutfest/core/helpers/attendance_helper.dart';
import 'package:flutfest/core/helpers/event_helpers.dart'; // يحتوي formatEventDate
import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/favorite_controller.dart';
import 'package:flutfest/logic/controllers/user_controller.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/widgets/buttons/primary_button.dart';
import 'package:flutfest/widgets/dialogs/custom_success_dialog.dart';
import 'package:flutfest/widgets/dialogs/dialog_action_button.dart';
import 'package:flutfest/widgets/images/event_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

// يحتوي handleAttendance

class EventCard extends StatelessWidget {
  final EventModel event;
  final void Function(EventModel)? onEventTap;

  const EventCard({super.key, required this.event, this.onEventTap});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final eventController = Get.find<EventController>();
    final userController = Get.find<UserController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: InkWell(
        onTap: () => onEventTap?.call(event),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Hero(
              
                tag: 'event-${event.eventId}',
                child: EventImage(event: event, imageHeight: 150),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title ?? '',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(formatEventDate(event),
                        style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text('Location: ${event.location}',
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(event.description ?? '',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Obx(() {
                      final attending = eventController.isUserAttending(
                          event.eventId, userController.currentUserId.value);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PrimaryButton(
                            text: attending ? 'Cancel Attending' : 'Attend Now',
                            onPressed: () async {
                              await handleAttendance(event.eventId);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              SharePlus.instance.share(ShareParams(
                                text:
                                    'Check out this event: ${event.title}\n${formatEventDate(event)}\nLocation: ${event.location}\n\n${event.description}',
                                subject: 'FlutFest Event: ${event.title}',
                              ));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => CustomAlertDialog(
                                  title: 'Confirm Delete',
                                  content:
                                      'Are you sure you want to delete this event?',
                                  actions: [
                                    DialogActionButton(
                                      label: 'Cancel',
                                      onPressed: () => Get.back(),
                                    ),
                                    DialogActionButton(
                                        label: 'Delete',
                                        onPressed: () {
                                          eventController
                                              .deleteEvent(event.eventId);
                                          Get.back();
                                        }),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                showCustomSnackBar(
                                    'Event deleted successfully.');
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteController
                                          .favoriteEvents[event.eventId] ==
                                      true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteController
                                          .favoriteEvents[event.eventId] ==
                                      true
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              favoriteController.toggleFavorite(event.eventId);
                              showCustomSnackBar(favoriteController
                                          .favoriteEvents[event.eventId] ==
                                      true
                                  ? 'Added to favorites'
                                  : 'Removed from favorites');
                            },
                          ),
                        ],
                      );
                    }),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
