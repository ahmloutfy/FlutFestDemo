import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  String _pickedAddress = 'Select a location on the map';

  final TextEditingController _searchController = TextEditingController();
  final Geocoding _geocoding = Geocoding();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission', 'Location permission denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      );

      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
      });
      await _updateAddressFromLocation(_pickedLocation!);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not get current location');
    }
  }

  void _onTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    _updateAddressFromLocation(position);

  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_pickedLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
      );

    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      Get.snackbar('Warning', 'Please enter a location to search');
      return;
    }

    try {
      final locations = await _geocoding.locationFromAddress(query);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        final pos = LatLng(loc.latitude, loc.longitude);

        setState(() {
          _pickedLocation = pos;
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(pos, 15),
        );

        await _updateAddressFromLocation(pos);
        if (!mounted) return;
        // Focus out from keyboard
        FocusScope.of(context).unfocus();
      } else {
        Get.snackbar('Not found', 'No results found for "$query". Try a more specific address.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search location. Please check your internet or try different keywords.');
      debugPrint('Geocoding error: $e');
    }
  }

  Future<void> _updateAddressFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        setState(() {
          _pickedAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((part) => part != null && part.isNotEmpty).join(', ');
        });
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
      setState(() {
        _pickedAddress = '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.033333, 31.233334),
              zoom: 12,
            ),
            onTap: _onTap,
            onMapCreated: _onMapCreated,
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('picked'),
                position: _pickedLocation!,
              )
            }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search location',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.blue),
                        onPressed: _performSearch,
                      ),
                    ],
                  ),
                ),
                onSubmitted: (value) => _performSearch(),   // لا يزال يعمل مع Enter
                onChanged: (value) {
                  setState(() {}); // لتحديث الـ clear button
                },
              ),
            ),
          ),

          if (_pickedLocation != null)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Select This Location'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.back(result: {
                    'lat': _pickedLocation!.latitude,
                    'lng': _pickedLocation!.longitude,
                    'address': _pickedAddress,
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}