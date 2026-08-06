import 'dart:convert';

import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/core/utils/dummy_events.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum AttendanceResult {
  attending,
  cancelled,
  expired,
}

class EventController extends GetxController {
  final events = <EventModel>[...DummyEvents.events].obs;
  final Uuid eventUuid = Uuid();

  @override
  void onInit() async {
    // await clearEvents();
    _loadEvents();
    super.onInit();
  }

  /// Add userId to joinedUserIds if not present and persist changes.
  Future<void> attendEvent(String eventId, String userId) async {
    final index = events.indexWhere((e) => e.eventId == eventId);
    if (index == -1) return;
    final event = events[index];
    if (event.endDate != null && event.endDate!.isBefore(DateTime.now())) {
      showCustomSnackBar('Event has already ended');
      return;
    }
    final updatedJoinedUsers = List<String>.from(event.joinedUserIds ?? []);
    if (!updatedJoinedUsers.contains(userId)) {
      updatedJoinedUsers.add(userId);
      final updatedEvent = event.copyWith(joinedUserIds: updatedJoinedUsers);
      events[index] = updatedEvent;
      events.refresh();
      await saveEventsToPrefs(events);
    }
  }

  /// Remove userId from joinedUserIds if present and persist changes.
  Future<void> unAttendEvent(String eventId, String userId) async {
    final index = events.indexWhere((e) => e.eventId == eventId);
    if (index == -1) return;
    final event = events[index];
    final updatedJoinedUsers = List<String>.from(event.joinedUserIds ?? []);
    if (updatedJoinedUsers.contains(userId)) {
      updatedJoinedUsers.remove(userId);
      final updatedEvent = event.copyWith(joinedUserIds: updatedJoinedUsers);
      events[index] = updatedEvent;
      events.refresh();
      await saveEventsToPrefs(events);
    }
  }


  Future<AttendanceResult> toggleAttendance(String eventId, String userId) async {
    final index = events.indexWhere((e) => e.eventId == eventId);
    if (index == -1) return AttendanceResult.cancelled;
    final event = events[index];

    if (event.endDate != null && event.endDate!.isBefore(DateTime.now())) {
      return AttendanceResult.expired;
    }

    final updatedJoinedUsers = List<String>.from(event.joinedUserIds ?? []);
    if (updatedJoinedUsers.contains(userId)) {
      updatedJoinedUsers.remove(userId);
      events[index] = event.copyWith(joinedUserIds: updatedJoinedUsers);
      events.refresh();
      await saveEventsToPrefs(events);
      return AttendanceResult.cancelled;
    } else {
      updatedJoinedUsers.add(userId);
      events[index] = event.copyWith(joinedUserIds: updatedJoinedUsers);
      events.refresh();
      await saveEventsToPrefs(events);
      return AttendanceResult.attending;
    }
  }


  void addEvent(EventModel event) async {
    events.insert(0, event);
    await saveEventsToPrefs(events);
  }

  void removeEvent(EventModel event) async {
    events.remove(event);
    await saveEventsToPrefs(events);
  }

  void deleteEvent(String eventId) async {
    events.removeWhere((e) => e.eventId == eventId);
    await saveEventsToPrefs(events);
  }

  void updateEvent(EventModel updatedEvent) async {
    final index = events.indexWhere((e) => e.eventId == updatedEvent.eventId);
    if (index != -1) {
      events[index] = updatedEvent;
      events.refresh();
      await saveEventsToPrefs(events);
    }
  }

  Future<void> saveEventsToPrefs(List<EventModel> events) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = events.map((e) => e.toJson()).toList();
    await prefs.setString('events', jsonEncode(jsonList));
  }

  Future<void> inspectPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('events');
    if (kDebugMode) {
      print('RAW events key: $raw');
    }
    final backup = prefs.getString('events_backup');
    if (kDebugMode) {
      print('RAW events_backup key: $backup');
    }
  }

  Future<List<EventModel>> loadEventsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('events');
    if (jsonString == null) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((rawEvent) {
            final event = Map<String, dynamic>.from(rawEvent);
            // eventId is the only required non-null field. Old or corrupted
            // browser storage can contain records without it.
            if (event['eventId'] is! String) return null;
            return EventModel.fromJson(event);
          })
          .whereType<EventModel>()
          .toList();
    } catch (error) {
      debugPrint('Ignoring invalid saved events: $error');
      return [];
    }
  }

  void _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt('dummy_version') ?? 0;
    final loadedEvents = await loadEventsFromPrefs();

    // 1. If the version matches and local data exists, load it directly and return
    if (savedVersion == DummyEvents.version && loadedEvents.isNotEmpty) {
      events.assignAll(loadedEvents);
      return;
    }

    // 2. Perform a Smart Merge if the version changed or data is empty
    // Using a Map ensures that each eventId remains unique
    final Map<String, EventModel> finalMap = {};

    // A. Add Dummy events first (they provide the latest updated content/images)
    for (var dummy in DummyEvents.events) {
      finalMap[dummy.eventId] = dummy;
    }

    // B. Process previously loaded events to maintain user interactions
    for (var loaded in loadedEvents) {
      if (finalMap.containsKey(loaded.eventId)) {
        // If the event exists in Dummy data, preserve the 'joinedUserIds' from the local storage
        finalMap[loaded.eventId] = finalMap[loaded.eventId]!.copyWith(
          joinedUserIds: loaded.joinedUserIds,
        );
      } else {
        // If the event is not in Dummy data, it's a custom user event; keep it as is
        finalMap[loaded.eventId] = loaded;
      }
    }

    // 3. Convert Map values back to a List and update the observable state
    events.assignAll(finalMap.values.toList());

    // 4. Persist the new merged list and update the version in SharedPreferences
    await saveEventsToPrefs(events);
    await prefs.setInt('dummy_version', DummyEvents.version);
  }


  Future<void> clearEvents() async {
    events.clear();
    await saveEventsToPrefs(events);
  }

  Future<void> resetToDummy() async {
    events.assignAll(DummyEvents.events);
    await saveEventsToPrefs(events);
  }

  List<EventModel> getUpcomingEvents() {
    final now = DateTime.now();
    // Upcoming if the event has not ended yet
    return events.where((e) => e.endDate != null && e.endDate!.isAfter(now)).toList();
  }

  List<EventModel> getExpiredEvents() {
    final now = DateTime.now();
    // Expired if the event has already ended
    return events.where((e) => e.endDate != null && e.endDate!.isBefore(now)).toList();
  }

  bool isUserAttending(String eventId, String userId) {
    final event = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (event == null) return false;
    return event.joinedUserIds?.contains(userId) ?? false;
  }
}
