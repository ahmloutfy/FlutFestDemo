import 'package:flutfest/logic/controllers/edit_profile_controller.dart';
import 'package:flutfest/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() {
              return CircleAvatar(
                radius: 50,
                backgroundImage: controller.profileImage.value != null
                    ? FileImage(controller.profileImage.value!)
                    : const AssetImage('assets/images/user.png')
                        as ImageProvider,
              );
            }),
            TextButton.icon(
              onPressed: () => controller.showImageSourceDialog(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Change Photo'),
            ),
            const SizedBox(height: 24),
            CustomTextField(
                controller: controller.nameController, label: 'Name'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: controller.emailController, label: 'Email'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: () => controller.saveChanges(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
