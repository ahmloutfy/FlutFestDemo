import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutter/material.dart';

class AddToCalendarButton extends StatelessWidget {
  final EventModel event;

  const AddToCalendarButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.edit_calendar),
      onPressed: () {
        // final add2cal.Event calendarEvent = add2cal.Event(
        //   title: event.title ?? '',
        //   description: event.description ?? '',
        //   location: event.location ?? '',
        //   startDate: event.startDate!,
        //   endDate: event.endDate!.add(const Duration(hours: 2)),
        // );
        // add2cal.Add2Calendar.addEvent2Cal(calendarEvent);
      },
      label: const Text('Add to Calendar'),
    );
  }
}
