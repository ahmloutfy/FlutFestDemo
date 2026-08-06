import 'dart:io';
import 'package:flutfest/core/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController(text: 'John Doe');
  final emailController = TextEditingController(text: 'johndoe@example.com');

  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final RxString profileImagePath = 'assets/images/user.png'.obs;

  void updateProfileImage(String newPath) {
    profileImagePath.value = newPath;
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  void showImageSourceDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Select Image Source',
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Get.back();
              pickProfileImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Get.back();
              pickProfileImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  void saveChanges(BuildContext context) {
    final name = nameController.text;
    final email = emailController.text;

    // 👇 Here you can add code to save in Storage or send to API later

// Just an internal update in the package
    debugPrint('Saved Name: $name');
    debugPrint('Saved Email: $email');
    debugPrint('Saved Image: ${profileImage.value?.path ?? "default"}');

    // Return back with a success message
    Get.back();
    showCustomSnackBar('Profile updated successfully');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
