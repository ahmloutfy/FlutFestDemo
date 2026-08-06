import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutfest/logic/controllers/favorite_controller.dart';
import 'package:flutfest/views/details/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.widget});

  final EventDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Text('Add to favorites'),
      onPressed: () async {
        final favoriteController = Get.find<FavoriteController>();
        final isNowFavorite =
            favoriteController.toggleFavorite(widget.event.eventId);
        showCustomSnackBar(
          await isNowFavorite ? 'Added to favorites' : 'Removed from favorites',
        );
      },
      icon: GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (favController) {
          return Icon(
            color: favController.favoriteEvents.containsKey(widget.event.eventId) &&
                    favController.favoriteEvents[widget.event.eventId]!
                ? Colors.red
                : Colors.white,
            favController.isFavorite(widget.event.eventId)
                ? Icons.favorite
                : Icons.favorite_border,
          );
        },
      ),
    );
  }
}
