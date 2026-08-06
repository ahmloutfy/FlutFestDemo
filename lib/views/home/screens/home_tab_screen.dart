import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/core/widgets/platform_banner_ad.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/favorite_controller.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/views/home/components/event_card.dart';
import 'package:flutfest/views/home/components/events_categories.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  // 1. Reactive state for the selected tab
  final RxString selectedTab = 'All'.obs;

  // Controllers
  late final FavoriteController favController;
  late final EventController eventController;

  @override
  void initState() {
    super.initState();
    favController = Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController());
    eventController = Get.isRegistered<EventController>()
        ? Get.find<EventController>()
        : Get.put(EventController(), permanent: true);

  }

  /// Filters events based on the selected tab and the current date (2026)
  List<EventModel> getFilteredEvents() {
    final now = DateTime.now();

    return eventController.events.where((event) {
      final end = event.endDate;

      switch (selectedTab.value) {
        case 'Upcoming':
        // Show if the event hasn't ended yet OR is specifically flagged for demo
          return (end != null && end.isAfter(now)) ||
              (event.isUpcomingForDemo == true);

        case 'Expired':
        // Show all events where the end date has passed
          return end != null && end.isBefore(now);

        case 'Favorites':
        // Show only events marked as favorite in FavoriteController
          return favController.favoriteEvents[event.eventId] == true;

        case 'All':
        default:
          return true;
      }
    }).toList();
  }

  void _navigateToEventDetails(EventModel event) {
    Get.toNamed(Routes.eventDetails, arguments: event);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        return Column(
          children: [
            // Category Selection Row
            Obx(() => SizedBox(
              width: double.infinity,
              // EventsCategories already contains a horizontal ListView.
              // Wrapping it in another horizontal scroll view on wide web
              // layouts gives it an unbounded width and prevents Home from
              // rendering.
              child: EventsCategories(
                selectedTab: selectedTab.value,
                onTabSelected: (tab) {
                  selectedTab.value = tab;
                  showCustomSnackBar('$tab events');
                },
              ),
            )),

            // Events List
            Expanded(
              child: Obx(() {
                final filteredEvents = getFilteredEvents();
                if (filteredEvents.isEmpty) {
                  return const Center(
                    child: Text("No events found in this category", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async { await Future.delayed(const Duration(milliseconds: 500)); },
                  child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return EventCard(event: event, onEventTap: _navigateToEventDetails);
                  },
                ),

                );

              }),
            ),

            const PlatformBannerAd(),

          ],
        );
      },
    );
  }
}
