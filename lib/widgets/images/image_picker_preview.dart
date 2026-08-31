import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPreview extends StatelessWidget {
  final XFile? imageFile;
  final String? imageUrl;

  const ImagePickerPreview({
    super.key,
    this.imageFile,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return FutureBuilder(
        future: imageFile!.readAsBytes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              snapshot.data!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      } else if (imageUrl!.startsWith('data:image/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('No image selected'),
      ),
    );
  }
}
