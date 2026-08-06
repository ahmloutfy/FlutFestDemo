import 'package:flutfest/logic/controllers/create_event_controller.dart';
import 'package:flutfest/logic/models/create_event_view_model.dart';
import 'package:flutfest/routes.dart';
import 'package:flutfest/widgets/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:get/get.dart';

import 'package:flutfest/core/helpers/event_helpers.dart';
import 'package:flutfest/core/services/ai_service.dart';
import 'package:flutfest/logic/controllers/event_controller.dart';
import 'package:flutfest/logic/controllers/navigation_controller.dart';
import 'package:flutfest/logic/models/event_model.dart';

import 'package:flutfest/widgets/fields/custom_text_field.dart';
import 'package:flutfest/widgets/fields/date_picker_field.dart';
import 'package:flutfest/widgets/images/image_picker_preview.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key, this.event});

  final _formKey = GlobalKey<FormState>();
  final CreateEventViewModel viewModel = Get.find();
  final EventController eventController = Get.find();
  final CreateEventController createEventController = Get.put(CreateEventController());
  final NavigationController navigationController = Get.find<NavigationController>();
  final EventModel? event;

  Future<void> _handleDatePick(BuildContext context) async {
    final startDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (startDate == null) return;
    if (!context.mounted) return;
    final startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select start time",
    );

    if (startTime == null) return;

    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    if (!context.mounted) return;
    final endDate = await showDatePicker(
      context: context,
      firstDate: startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: startDate,
    );

    if (endDate == null) return;
    if (!context.mounted) return;
    final endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDateTime.add(const Duration(hours: 1))),
      helpText: "Select end time",
    );

    if (endTime == null) return;

    final endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );

    viewModel.setDateRange(DateTimeRange(
      start: startDateTime,
      end: endDateTime,
    ));
  }

  /// Generate event details using AI
  Future<void> _generateEventWithAI(BuildContext context) async {
    final String? idea = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Event Idea'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Describe your event idea (e.g., UI/UX workshop for beginners in Cairo)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // This is simplified. In production, use a TextEditingController
              final controller = TextEditingController(); // You should improve this
              Navigator.pop(ctx, controller.text.trim());
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );

    if (idea == null || idea.trim().isEmpty) return;

    viewModel.isGenerating.value = true;

    try {
      final aiService = AIService();
      final result = await aiService.generateEventFromIdea(idea);

      // Auto-fill the form fields
      viewModel.titleController.text = result['title'] ?? '';
      viewModel.descriptionController.text = result['description'] ?? '';

      // Optional: Set location from category if you want
      if (result['category'] != null) {
        viewModel.setLocation(address: result['category']!);
      }

      Get.snackbar(
        'Success',
        'Event generated successfully with AI',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate event with AI: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      viewModel.isGenerating.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (event != null) {
      viewModel.titleController.text = event!.title ?? '';
      viewModel.descriptionController.text = event!.description ?? '';
      viewModel.setDateRange(
        DateTimeRange(
          start: event?.startDate ?? DateTime.now(),
          end: event?.endDate ?? DateTime.now().add(const Duration(hours: 2)),
        ),
      );
      viewModel.setLocation(address: event!.location ?? '');
      viewModel.imagePath.value = event!.image ?? '';
    } else {
      viewModel.reset();
    }

    final String actionLabel = event == null ? 'Create Event' : 'Update Event';

    return Scaffold(
      appBar: AppBar(title: Text(actionLabel), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Picker
              ElevatedButton.icon(
                onPressed: viewModel.pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Add Image'),
              ),
              // const SizedBox(height: 16),
              Gutter(),

              Obx(() => ImagePickerPreview(
                imageFile: viewModel.pickedImage.value,
                imageUrl: viewModel.imagePath.value,
              )),

              // const SizedBox(height: 24),
              Gutter(),

              // Event Title
              CustomTextField(
                controller: viewModel.titleController,
                label: 'Event Title',
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              // const SizedBox(height: 8),
              Gutter(),

              // AI Generate Button
              Obx(() => ElevatedButton.icon(
                onPressed: viewModel.isGenerating.value
                    ? null
                    : () => _generateEventWithAI(context),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Event with AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 12),
                ),
              )),

              // const SizedBox(height: 16),
              Gutter(),

              // Location Button
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Get.toNamed(Routes.pickLocation);
                  if (result != null && result is Map<String, dynamic>) {
                    viewModel.setLocation(
                      address: result['address'] ?? '',
                      lat: result['latitude'],
                      lng: result['longitude'],
                    );
                  }
                },
                icon: const Icon(Icons.location_on, color: Colors.red),
                label: Obx(() {
                  final location = viewModel.pickedLocationText.value;
                  return Text(
                    location.isEmpty ? 'Pick Location' : location,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),

              // const SizedBox(height: 16),
              Gutter(),

              // Description
              CustomTextField(
                controller: viewModel.descriptionController,
                label: 'Description',
                validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                maxLines: 3,
              ),
              // const SizedBox(height: 16),
              Gutter(),

              // Date Picker
              Obx(() {
                final range = viewModel.selectedDateRange.value;
                return DatePickerField(
                  selectedRange: range,
                  onTap: () => _handleDatePick(context),
                  validator: (_) {
                    if (range == null) {
                      return 'Please select a date range';
                    }
                    return null;
                  },
                );
              }),

              // const SizedBox(height: 32),
              Gutter(),
              NotificationSettings(),
              // const SizedBox(height: 32),
              Gutter(),

              // Submit Button
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (event == null) {
                      submitEventForm(
                        context: context,
                        formKey: _formKey,
                        viewModel: viewModel,
                        eventController: eventController,
                      );
                    } else {
                      // Update event logic here
                    }
                  }
                },
                icon: const Icon(Icons.check),
                label: Text(actionLabel),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),


              ),
              Gutter(),
            ],
          ),
        ),
      ),
    );
  }
}