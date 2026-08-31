import 'package:flutfest/core/utils/dummy_events.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Upcoming Event Reminder',
      'message': 'The event will start tomorrow at 8:00 PM.',
      'time': '5 minutes ago',
      'eventId': 6, // Music Concert
    },
    {
      'title': 'Attending Status Updated',
      'message': 'Your VIP ticket attending has been confirmed.',
      'time': '30 minutes ago',
      'eventId': 9, // Art Exhibition
    },
    {
      'title': 'Important Announcement',
      'message':
          'The registration period has been extended until the end of the week.',
      'time': '1 hour ago',
      'eventId': 7, // Cultural Festival
    },
  ];

  EventModel getEventById(int id) {
    return DummyEvents.events.firstWhere((event) => event.eventId == id.toString());
  }

  void _refreshNotifications() {
    setState(() {
      // simulate clearing notifications for testing
      notifications.clear();
      // Or simulate new fetch logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: theme.textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
            tooltip: 'Refresh Notifications',
          ),
        ],
      ),
      body:
          notifications.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You\'re all caught up!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No new notifications at the moment.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.home),
                        label: const Text('Back to Home'),
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(
                    context,
                    title: notification['title'],
                    message: notification['message'],
                    time: notification['time'],
                    icon: Icons.event_note,
                    onTap: () {
                       Get.toNamed( Routes. eventDetails, arguments: getEventById(notification['eventId']));
                    },
                  );
                },
              ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    IconData? icon,
    final Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon ?? Icons.notifications_active,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
