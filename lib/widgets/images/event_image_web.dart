import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  const EventImage({super.key, required this.event, this.imageHeight});

  final EventModel event;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    final imagePath = event.image;
    if (imagePath == null || imagePath.isEmpty) return _unsupportedImage();

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        alignment: const Alignment(0, -0.3),
        height: imageHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _unsupportedImage(),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        alignment: const Alignment(0, -0.3),
        height: imageHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _unsupportedImage(),
      );
    }

    return _unsupportedImage();
  }

  Widget _unsupportedImage() => SizedBox(
        height: imageHeight ?? 150,
        child: const Center(child: Icon(Icons.broken_image)),
      );
}
