import 'package:flutfest/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/models/event_model.dart';

import '../../../logic/controllers/user_controller.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final String currentUserId = userController.currentUserId.value;

    final eventController = Get.find<EventController>();

    return DefaultTabController(
      length: 2,
      child: Obx(() {
        List<EventModel> createdEvents = eventController.events
            .where((event) => event.creatorId == currentUserId)
            .toList();

        List<EventModel> joinedEvents = eventController.events.where((event) {
          return (event.joinedUserIds ?? []).contains(currentUserId);
        }).toList();

        return Column(
          children: [
            Material(
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              child: TabBar(
                dividerColor: Colors.transparent,
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Tab(text: 'Created'),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Tab(text: 'Attended'),
                  ),

                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  EventList(
                    events: createdEvents,
                    emptyMessage: 'Events you created will appear here.',
                  ),
                  EventList(
                    events: joinedEvents,
                    emptyMessage: 'Events you joined will appear here.',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}