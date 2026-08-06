import 'package:flutfest/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.toNamed(Routes.createEvent);
      },
      icon: Icon(Icons.add),
      label: Text('Create Event'),
    );
  }
}
