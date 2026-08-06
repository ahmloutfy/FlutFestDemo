import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutfest/logic/controllers/navigation_controller.dart';
import 'package:flutfest/views/accounts/account_screen.dart';
import 'package:flutfest/views/events/screens/my_events_screen.dart';
import 'package:flutfest/views/home/screens/home_tab_screen.dart';
import 'package:flutfest/widgets/buttons/create_event_button.dart';
import 'package:flutfest/widgets/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> screens = const [
    HomeTabScreen(),
    MyEventsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        appBar: customAppBar(context, 'Welcome User'),
        floatingActionButton: navController.currentIndex.value == 0 ||
            navController.currentIndex.value == 1
            ? Padding(
          padding: const EdgeInsets.only(bottom: 45.0),
          child: CreateEventButton(),)
            : null,
        body: screens[navController.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.setIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'My Events'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}