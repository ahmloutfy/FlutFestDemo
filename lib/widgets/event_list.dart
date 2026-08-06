import 'package:flutfest/core/helpers/event_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic/controllers/navigation_controller.dart';
import '../logic/models/event_model.dart';
import 'images/event_image.dart';
import '../routes.dart';

class EventList extends StatelessWidget {
  final List<EventModel> events;
  final String emptyMessage;

  const EventList({
    super.key,
    required this.events,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No events yet!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                navigationController.goToHomeTab();
              },
              icon: const Icon(Icons.explore),
              label: const Text('Explore Events'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 60,
                height: 60,
                child: EventImage(event: event, imageHeight: 60),
              ),
            ),
            title: Text(event.title ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (event.description ?? '').length > 40
                      ? '${event.description!.substring(0, 40)}...'
                      : (event.description ?? ''),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  formatEventDate(event),
                  style: Theme.of(context).textTheme.labelSmall,
                ),


              ],
            ),


            onTap: () {
              Get.toNamed(Routes.eventDetails, arguments: event);
            },
          ),
        );
      },
    );
  }
}