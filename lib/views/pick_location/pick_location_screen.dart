import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

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

  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) Get.snackbar('Permission', 'Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          Get.snackbar(
              'Permission', 'Location permissions are permanently denied');
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      final newPos = LatLng(position.latitude, position.longitude);
      setState(() {
        _pickedLocation = newPos;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPos, 15),
      );

      await _updateAddressFromLocation(newPos);
    } catch (e) {
      debugPrint('Location Error: $e');
      if (mounted) {
        Get.snackbar('Error',
            'Could not get current location. Please ensure GPS is on.');
      }
    }
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (query.length < 3) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 700), () async {
      setState(() {
        _isSearching = true;
      });

      try {
        // Requesting results in both Arabic and English to ensure the best coverage
        final locations = await _geocoding.locationFromAddress(query);

        List<Map<String, dynamic>> tempSuggestions = [];

        for (var loc in locations.take(5)) {
          try {
            final placemarks = await _geocoding.placemarkFromCoordinates(
              loc.latitude,
              loc.longitude,
            );

            if (placemarks.isNotEmpty) {
              final p = placemarks.first;
              final name = _buildCleanAddress(p);

              // Avoid duplicate places in the list
              if (!tempSuggestions.any((s) => s['display'] == name)) {
                tempSuggestions.add({
                  'display': name,
                  'lat': loc.latitude,
                  'lng': loc.longitude,
                });
              }
            }
          } catch (_) {}
        }

        if (mounted) {
          setState(() {
            _suggestions = tempSuggestions;
            _isSearching = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  String _buildCleanAddress(Placemark p) {
    // Put p.name at the beginning because it's often the landmark name (e.g., Pyramids or street name)
    final parts = [
      p.name,
      p.subLocality,
      p.locality,
      p.administrativeArea,
    ];

    final cleanParts = <String>[];
    for (var part in parts) {
      if (part != null && part.isNotEmpty && !part.contains('+')) {
        // Avoid duplicate similar words (e.g., if the name is the same as the city)
        if (!cleanParts.any(
            (element) => element.contains(part) || part.contains(element))) {
          cleanParts.add(part);
        }
      }
    }

    if (cleanParts.isEmpty) {
      return p.name ?? 'Unknown Location';
    }

    // Take the first 3 parts to have a focused and useful address
    return cleanParts.take(3).join(', ');
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _suggestions = []);

    try {
      final locations = await _geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _selectPosition(LatLng(loc.latitude, loc.longitude));
      }
    } catch (e) {
      Get.snackbar('Not Found', 'Could not find "$query"');
    }
  }

  void _selectPosition(LatLng pos) async {
    setState(() {
      _pickedLocation = pos;
      _suggestions = [];
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(pos, 15),
    );

    await _updateAddressFromLocation(pos);

    // Update the search box with the clean address to be clear to the user
    setState(() {
      _searchController.text = _pickedAddress;
    });

    FocusScope.of(context).unfocus();
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

  Future<void> _updateAddressFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _pickedAddress = _buildCleanAddress(placemarks.first);
        });
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
      setState(() {
        _pickedAddress =
            '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}';
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

          // Search Bar & Suggestions
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: _isSearching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)))
                          : const Icon(Icons.search),
                      hintText: 'Search location...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _onSearchChanged,
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),

                // Suggestions List
                if (_suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).cardColor,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined,
                                color: Colors.blue),
                            title: Text(suggestion['display'],
                                style: const TextStyle(fontSize: 14)),
                            onTap: () {
                              _searchController.text = suggestion['display'];
                              _selectPosition(
                                  LatLng(suggestion['lat'], suggestion['lng']));
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
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
