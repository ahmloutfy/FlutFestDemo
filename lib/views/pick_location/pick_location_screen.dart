import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  bool _hasLocationPermission = false;

  // Google Maps API Key for Places (Updated to match your console settings)
  final String _googleMapsKey = 'AIzaSyAFjAwgUvo6QWMI9Z2OFuIlHq7kLeg9I9k';

  @override
  void initState() {
    super.initState();
    // Delay location request until after the first frame to prevent ANR (App Not Responding)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
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
          timeLimit: Duration(seconds: 8),
        ),
      );

      if (!mounted) return;

      setState(() {
        _hasLocationPermission = true;
        _pickedLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
      );

      await _updateAddressFromLocation(_pickedLocation!);
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

    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      setState(() {
        _isSearching = true;
      });

      try {
        final String url =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleMapsKey&language=en';
        
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          
          if (data['status'] == 'OK') {
            final predictions = data['predictions'] as List;
            if (mounted) {
              setState(() {
                _suggestions = predictions.map((p) => {
                  'display': p['description'],
                  'place_id': p['place_id'],
                }).toList();
                _isSearching = false;
              });
            }
          } else {
            // If Places API fails (e.g., billing not linked or key restriction), fallback to Geocoding API
            debugPrint('Places API Status: ${data['status']} (${data['error_message']}), falling back to Geocoding API.');
            await _fallbackGeocodingSearch(query);
          }
        } else {
          await _fallbackGeocodingSearch(query);
        }
      } catch (e) {
        await _fallbackGeocodingSearch(query);
      }
    });
  }

  Future<void> _fallbackGeocodingSearch(String query) async {
    try {
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
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _suggestions = []);

    try {
      final locations = await _geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _selectPosition(LatLng(loc.latitude, loc.longitude), cleanAddress: query);
      }
    } catch (e) {
      Get.snackbar('Not Found', 'Could not find "$query"');
    }
  }

  Future<void> _getPlaceDetails(String placeId, {String? suggestionDisplay}) async {
    setState(() {
      _isSearching = true;
      _suggestions = [];
    });

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry,formatted_address&key=$_googleMapsKey';
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        final lat = result['geometry']['location']['lat'];
        final lng = result['geometry']['location']['lng'];
        final name = result['name'] as String?;
        final formattedAddress = result['formatted_address'] as String?;

        String finalAddress;
        if (suggestionDisplay != null && suggestionDisplay.isNotEmpty) {
          finalAddress = suggestionDisplay;
        } else if (name != null && name.isNotEmpty) {
          if (formattedAddress != null && formattedAddress.isNotEmpty && !formattedAddress.contains(name)) {
            finalAddress = '$name, $formattedAddress';
          } else {
            finalAddress = name;
          }
        } else {
          finalAddress = formattedAddress ?? '';
        }

        _selectPosition(LatLng(lat, lng), cleanAddress: finalAddress);
      }
    } catch (e) {
      debugPrint('Place Details Error: $e');
      Get.snackbar('Error', 'Failed to get location details');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectPosition(LatLng pos, {String? cleanAddress}) async {
    if (!mounted) return;
    setState(() {
      _pickedLocation = pos;
      _suggestions = [];
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(pos, 15),
    );

    if (cleanAddress != null) {
      setState(() {
        _pickedAddress = cleanAddress;
        _searchController.text = cleanAddress;
      });
    } else {
      await _updateAddressFromLocation(pos);
      if (mounted) {
        setState(() {
          _searchController.text = _pickedAddress;
        });
      }
    }

    if (mounted) {
      FocusScope.of(context).unfocus();
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

  Future<void> _updateAddressFromLocation(LatLng location) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _pickedAddress = _buildCleanAddress(placemarks.first);
        });
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
      if (!mounted) return;
      setState(() {
        _pickedAddress =
            '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}';
      });
    }
  }

  String _buildCleanAddress(Placemark p) {
    final parts = [
      p.name,
      p.subLocality,
      p.locality,
      p.administrativeArea,
    ];
    
    final cleanParts = <String>[];
    for (var part in parts) {
      if (part != null && part.isNotEmpty && !part.contains('+')) {
        if (!cleanParts.any((element) => element.contains(part) || part.contains(element))) {
          cleanParts.add(part);
        }
      }
    }

    if (cleanParts.isEmpty) {
      return p.name ?? 'Unknown Location';
    }
    
    return cleanParts.take(3).join(', ');
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
            myLocationEnabled: _hasLocationPermission,
            myLocationButtonEnabled: _hasLocationPermission,
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
                              if (suggestion['place_id'] != null) {
                                _getPlaceDetails(
                                  suggestion['place_id'],
                                  suggestionDisplay: suggestion['display'],
                                );
                              } else if (suggestion['lat'] != null) {
                                _selectPosition(
                                  LatLng(suggestion['lat'], suggestion['lng']),
                                  cleanAddress: suggestion['display'],
                                );
                              }
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
