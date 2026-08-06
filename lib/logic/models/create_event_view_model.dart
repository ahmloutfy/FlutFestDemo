import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventViewModel extends GetxController {
  // Text Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final Geocoding _geocoding = Geocoding();

  // Location
  RxString pickedLocationText = ''.obs;

  // Coordinates
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // Date Range
  Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  // Image
  Rx<File?> pickedImage = Rx<File?>(null);
  RxString imagePath = ''.obs;

  // AI Generation State
  RxBool isGenerating = false.obs;           // For AI Event Generator loading

  // Image Error State
  RxString imageError = ''.obs;              // ← رجعتها لك

  RxBool isPushEnabled = true.obs;
  RxBool isEmailEnabled = false.obs;
  RxInt selectedReminderMinutes = 15.obs; // Default to 15 minutes


  // ==================== Setters ====================

  void setDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
  }

  void setLocation({
    required String address,
    double? lat,
    double? lng,
  }) {
    String shortAddress = _getShortAddress(address);

    pickedLocationText.value = shortAddress;
    locationController.text = shortAddress;

    if (lat != null) latitude.value = lat;
    if (lng != null) longitude.value = lng;
  }

  String _getShortAddress(String fullAddress) {
    if (fullAddress.isEmpty) return 'Unknown Location';

    final parts = fullAddress.split(',').map((e) => e.trim()).toList();

    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0];
    if (parts.length > 1 && parts[1].isNotEmpty) return parts[1];
    if (parts.length > 2 && parts[2].isNotEmpty) return parts[2];

    return parts.first;
  }

  // ==================== Reverse Geocoding ====================
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final fullAddress = [
          placemark.name,
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        setLocation(address: fullAddress, lat: lat, lng: lng);
      } else {
        setLocation(address: '$lat, $lng', lat: lat, lng: lng);
      }
    } catch (e) {
      debugPrint('Reverse Geocoding Error: $e');
      setLocation(address: '$lat, $lng', lat: lat, lng: lng);
    }
  }

  // ==================== Reset ====================
  void reset() {
    titleController.clear();
    descriptionController.clear();
    locationController.clear();

    pickedLocationText.value = '';
    latitude.value = 0.0;
    longitude.value = 0.0;

    selectedDateRange.value = null;
    imagePath.value = '';
    pickedImage.value = null;
    isGenerating.value = false;
    imageError.value = '';
  }

  void resetForm() {
    reset();
  }

  // ==================== Image Picker ====================
  Future<void> pickImage() async {
    imageError.value = '';   // Clear previous error

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
      imagePath.value = pickedFile.path;
    } else {
      imageError.value = 'No image selected';
    }
  }

  // ==================== Getters ====================
  String get currentAddress => pickedLocationText.value;
  bool get hasLocation => pickedLocationText.value.isNotEmpty;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}