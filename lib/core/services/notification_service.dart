import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize notification settings for Android and iOS
  static Future<void> init() async {
    // flutter_local_notifications and flutter_timezone do not provide the
    // native scheduling APIs used below on the web. Returning here keeps web
    // startup independent from those platform implementations.
    if (kIsWeb) return;

    tz.initializeTimeZones();
    final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap logic here if needed
      },
    );
  }

  /// Request permissions for Android 13+ and iOS
  static Future<void> requestPermissions() async {
    if (kIsWeb) return;

    debugPrint('Requesting Notification Permissions...');
    // Request for Android (for versions that support it)
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    // Request for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Schedules a local notification for a specific event
  static Future<void> scheduleEventNotification(
      EventModel event, int minutesBefore) async {
    if (kIsWeb) return;

    if (event.startDate == null) return;

    // Calculate the notification time based on the offset
    final scheduledTime = event.startDate!.subtract(Duration(minutes: minutesBefore));

    debugPrint('Scheduling notification for event: ${event.title}');
    debugPrint('Event Start: ${event.startDate}');
    debugPrint('Remind before: $minutesBefore minutes');
    debugPrint('Scheduled Time (Local): $scheduledTime');

    // Ensure the scheduled time is in the future
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint('Warning: Scheduled time is in the past! Notification skipped.');
      return;
    }

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
    debugPrint('Scheduled Time (TZ): $tzTime');

    await _notifications.zonedSchedule(
      id: event.eventId.hashCode,
      title: 'Upcoming Event: ${event.title}',
      body: 'Reminder: Your event at ${event.location} starts soon!',
      scheduledDate: tzTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_channel_id',
          'Event Reminders',
          channelDescription: 'Notifications for upcoming events',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Pass event data to be retrieved when the user taps the notification
      payload: event.eventId,
    );
    debugPrint('Notification scheduled successfully with ID: ${event.eventId.hashCode}');
  }

  /// Cancels a specific scheduled notification using the event's unique ID
  static Future<void> cancelEventNotification(String eventId) async {
    if (kIsWeb) return;

    await _notifications.cancel(id: eventId.hashCode);
  }

  /// Cancels all scheduled notifications
  static Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;

    await _notifications.cancelAll();
  }
}
