import 'package:flutfest/views/details/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.widget,
    required this.formattedDate,
  });

  final EventDetailsScreen widget;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Text('Share the event'),
      onPressed: () {
        SharePlus.instance.share(
          ShareParams(
            text:
                'Check out this event: ${widget.event.title} - ${widget.event.location} on $formattedDate',
          ),
        );
      },
      icon: const Icon(Icons.share),
    );
  }
}
