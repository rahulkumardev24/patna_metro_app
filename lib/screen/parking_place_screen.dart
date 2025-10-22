import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:patna_metro/utils/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/parking_details_sheet.dart';

class ParkingPlaceScreen extends StatefulWidget {
  const ParkingPlaceScreen({super.key});

  @override
  State<ParkingPlaceScreen> createState() => _ParkingPlaceState();
}

class _ParkingPlaceState extends State<ParkingPlaceScreen> {
  final String apiKey = 'AIzaSyBHQG_W7m5-_ExoQ3aw4qm1I7SuGj4fp38';
  List<dynamic> parkingPlaces = [];
  List<dynamic> filteredParkingPlaces = [];
  late GoogleMapController mapController;
  LatLng patnaCenter = const LatLng(25.5941, 85.1376);
  bool isLoading = true;
  String errorMessage = '';
  Set<Marker> _markers = {};
  TextEditingController searchController = TextEditingController();
  Position? _currentPosition;
  bool _isSearching = false;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchParkingPlaces();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage =
              'Location permissions are permanently denied, we cannot request permissions.';
        });
        return;
      }

      // ✅ NEW METHOD (using LocationSettings)
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        errorMessage = 'Error fetching location: $e';
      });
    }
  }

  Future<void> fetchParkingPlaces() async {
    try {
      // First, try to get parking places from Google Places API
      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=25.5941,85.1376&radius=15000&type=parking&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> apiResults = data['results'] ?? [];

        // Combine with our predefined parking locations
        List<dynamic> allParkingPlaces = [
          ...apiResults,
          ..._getAdditionalParkingLocations(),
        ];

        setState(() {
          parkingPlaces = allParkingPlaces;
          filteredParkingPlaces = allParkingPlaces;
          isLoading = false;
          _updateMarkers();
        });
      } else {
        throw Exception('Failed to fetch parking data');
      }
    } catch (e) {
      // Fallback to predefined locations if API fails
      setState(() {
        parkingPlaces = _getAdditionalParkingLocations();
        filteredParkingPlaces = _getAdditionalParkingLocations();
        isLoading = false;
        _updateMarkers();
      });
    }
  }

  List<Map<String, dynamic>> _getAdditionalParkingLocations() {
    return [
      {
        'place_id': 'patna_parking_1',
        'name': 'Gandhi Maidan Parking',
        'geometry': {
          'location': {'lat': 25.6145, 'lng': 85.1397},
        },
        'vicinity': 'Ashok Rajpath, Patna',
        'rating': 4.2,
        'user_ratings_total': 150,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Large',
        'fee': '₹30/hour',
      },
      {
        'place_id': 'patna_parking_2',
        'name': 'Patna Junction Parking',
        'geometry': {
          'location': {'lat': 25.6093, 'lng': 85.1415},
        },
        'vicinity': 'Near Railway Station, Patna',
        'rating': 4.0,
        'user_ratings_total': 200,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Very Large',
        'fee': '₹40/hour',
      },
      {
        'place_id': 'patna_parking_3',
        'name': 'PMCH Parking Lot',
        'geometry': {
          'location': {'lat': 25.6114, 'lng': 85.1428},
        },
        'vicinity': 'Patna Medical College Hospital',
        'rating': 3.8,
        'user_ratings_total': 89,
        'opening_hours': {'open_now': true},
        'type': 'Hospital Parking',
        'capacity': 'Large',
        'fee': '₹20/hour',
      },
      {
        'place_id': 'patna_parking_4',
        'name': 'Boring Road Parking',
        'geometry': {
          'location': {'lat': 25.5996, 'lng': 85.0954},
        },
        'vicinity': 'Boring Canal Road, Patna',
        'rating': 4.1,
        'user_ratings_total': 75,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Medium',
        'fee': '₹35/hour',
      },
      {
        'place_id': 'patna_parking_5',
        'name': 'Patna Airport Parking',
        'geometry': {
          'location': {'lat': 25.5913, 'lng': 85.0890},
        },
        'vicinity': 'Jay Prakash Narayan Airport',
        'rating': 4.3,
        'user_ratings_total': 120,
        'opening_hours': {'open_now': true},
        'type': 'Airport Parking',
        'capacity': 'Large',
        'fee': '₹50/hour',
      },
      {
        'place_id': 'patna_parking_6',
        'name': 'Golghar Parking',
        'geometry': {
          'location': {'lat': 25.6187, 'lng': 85.1375},
        },
        'vicinity': 'Near Golghar, Patna',
        'rating': 4.0,
        'user_ratings_total': 95,
        'opening_hours': {'open_now': true},
        'type': 'Tourist Parking',
        'capacity': 'Medium',
        'fee': '₹25/hour',
      },
      {
        'place_id': 'patna_parking_7',
        'name': 'Patna Zoo Parking',
        'geometry': {
          'location': {'lat': 25.5991, 'lng': 85.1362},
        },
        'vicinity': 'Sanjay Gandhi Biological Park',
        'rating': 3.9,
        'user_ratings_total': 110,
        'opening_hours': {'open_now': true},
        'type': 'Tourist Parking',
        'capacity': 'Large',
        'fee': '₹30/hour',
      },
      {
        'place_id': 'patna_parking_8',
        'name': 'Mithapur Bus Stand Parking',
        'geometry': {
          'location': {'lat': 25.5816, 'lng': 85.1344},
        },
        'vicinity': 'Mithapur Bus Terminal',
        'rating': 3.7,
        'user_ratings_total': 65,
        'opening_hours': {'open_now': true},
        'type': 'Bus Stand Parking',
        'capacity': 'Very Large',
        'fee': '₹20/hour',
      },
      {
        'place_id': 'patna_parking_9',
        'name': 'Patna Metro Parking',
        'geometry': {
          'location': {'lat': 25.6012, 'lng': 85.1358},
        },
        'vicinity': 'Rajendra Nagar Metro Station',
        'rating': 4.2,
        'user_ratings_total': 45,
        'opening_hours': {'open_now': true},
        'type': 'Metro Parking',
        'capacity': 'Medium',
        'fee': '₹25/hour',
      },
      {
        'place_id': 'patna_parking_10',
        'name': 'Kankarbagh Parking',
        'geometry': {
          'location': {'lat': 25.6201, 'lng': 85.1489},
        },
        'vicinity': 'Kankarbagh Main Road',
        'rating': 4.0,
        'user_ratings_total': 80,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Medium',
        'fee': '₹30/hour',
      },
      {
        'place_id': 'patna_parking_11',
        'name': 'Exhibition Road Parking',
        'geometry': {
          'location': {'lat': 25.6158, 'lng': 85.1421},
        },
        'vicinity': 'Exhibition Road, Patna',
        'rating': 4.1,
        'user_ratings_total': 55,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Small',
        'fee': '₹40/hour',
      },
      {
        'place_id': 'patna_parking_12',
        'name': 'Fraser Road Parking',
        'geometry': {
          'location': {'lat': 25.6135, 'lng': 85.1389},
        },
        'vicinity': 'Fraser Road Area, Patna',
        'rating': 3.9,
        'user_ratings_total': 70,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Medium',
        'fee': '₹35/hour',
      },
      {
        'place_id': 'patna_parking_13',
        'name': 'Rajendra Nagar Parking',
        'geometry': {
          'location': {'lat': 25.6058, 'lng': 85.1284},
        },
        'vicinity': 'Rajendra Nagar, Patna',
        'rating': 4.0,
        'user_ratings_total': 60,
        'opening_hours': {'open_now': true},
        'type': 'Residential Parking',
        'capacity': 'Small',
        'fee': '₹25/hour',
      },
      {
        'place_id': 'patna_parking_14',
        'name': 'Danapur Parking Lot',
        'geometry': {
          'location': {'lat': 25.6378, 'lng': 85.0456},
        },
        'vicinity': 'Danapur Cantt, Patna',
        'rating': 3.8,
        'user_ratings_total': 40,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Medium',
        'fee': '₹20/hour',
      },
      {
        'place_id': 'patna_parking_15',
        'name': 'Patna City Parking',
        'geometry': {
          'location': {'lat': 25.6119, 'lng': 85.2083},
        },
        'vicinity': 'Patna City Area',
        'rating': 3.7,
        'user_ratings_total': 35,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Medium',
        'fee': '₹25/hour',
      },
      {
        'place_id': 'patna_parking_16',
        'name': 'Bailey Road Parking',
        'geometry': {
          'location': {'lat': 25.5998, 'lng': 85.1176},
        },
        'vicinity': 'Bailey Road, Patna',
        'rating': 4.1,
        'user_ratings_total': 85,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Large',
        'fee': '₹40/hour',
      },
      {
        'place_id': 'patna_parking_17',
        'name': 'Patliputra Parking',
        'geometry': {
          'location': {'lat': 25.5984, 'lng': 85.0958},
        },
        'vicinity': 'Patliputra Colony',
        'rating': 4.0,
        'user_ratings_total': 75,
        'opening_hours': {'open_now': true},
        'type': 'Commercial Parking',
        'capacity': 'Medium',
        'fee': '₹35/hour',
      },
      {
        'place_id': 'patna_parking_18',
        'name': 'Mohanpur Parking',
        'geometry': {
          'location': {'lat': 25.5876, 'lng': 85.1578},
        },
        'vicinity': 'Mohanpur, Patna',
        'rating': 3.6,
        'user_ratings_total': 30,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Small',
        'fee': '₹20/hour',
      },
      {
        'place_id': 'patna_parking_19',
        'name': 'Beur Parking Complex',
        'geometry': {
          'location': {'lat': 25.5756, 'lng': 85.0894},
        },
        'vicinity': 'Beur, Patna',
        'rating': 3.8,
        'user_ratings_total': 25,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Medium',
        'fee': '₹25/hour',
      },
      {
        'place_id': 'patna_parking_20',
        'name': 'Khagaul Parking',
        'geometry': {
          'location': {'lat': 25.5831, 'lng': 85.0539},
        },
        'vicinity': 'Khagaul, Patna',
        'rating': 3.5,
        'user_ratings_total': 20,
        'opening_hours': {'open_now': true},
        'type': 'Public Parking',
        'capacity': 'Small',
        'fee': '₹15/hour',
      },
    ];
  }

  void _updateMarkers() {
    _markers = filteredParkingPlaces
        .asMap()
        .map(
          (index, place) => MapEntry(
            index,
            Marker(
              markerId: MarkerId(place['place_id'] ?? 'marker_$index'),
              position: LatLng(
                place['geometry']['location']['lat'],
                place['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: place['name'],
                snippet: place['vicinity'] ?? 'No address',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
              onTap: () {
                _showParkingDetails(place, index);
              },
            ),
          ),
        )
        .values
        .toSet();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Current Location',
            snippet: 'You are here',
          ),
        ),
      );
    }
  }

  void _filterParkingPlaces(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredParkingPlaces = parkingPlaces;
      } else {
        filteredParkingPlaces = parkingPlaces.where((place) {
          final name = place['name']?.toString().toLowerCase() ?? '';
          final address = place['vicinity']?.toString().toLowerCase() ?? '';
          final type = place['type']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              address.contains(searchLower) ||
              type.contains(searchLower);
        }).toList();
      }
      _updateMarkers();
    });
  }

  void _showParkingDetails(Map<String, dynamic> place, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => ParkingDetailsSheet(
        place: place,
        currentPosition: _currentPosition,
        onGetDirections: _launchDirections,
      ),
    );
  }

  Future<void> _launchDirections(double destLat, double destLng) async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get your current location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String destination = '$destLat,$destLng';

    final String url =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _zoomToLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  void _zoomToCurrentLocation() {
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current location not available'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // App bar
      appBar: AppBar(
        title: const Text(
          "Parking Places",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white70,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white70),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
            tooltip: 'Search Location',
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white70),
            onPressed: _zoomToCurrentLocation,
            tooltip: 'Current Location',
          ),
        ],
      ),
      // body
      body: Column(
        children: [
          /// Search Bar
          _showSearch
              ? Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search parking by name, area, or type...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _isSearching
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                searchController.clear();
                                _filterParkingPlaces('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onChanged: _filterParkingPlaces,
                  ),
                )
              : SizedBox(),
          // Map Section
          Container(
            height: 50.w,
            decoration: BoxDecoration(),
            child: ClipRRect(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: patnaCenter,
                  zoom: 13,
                ),
                onMapCreated: (controller) => mapController = controller,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                mapToolbarEnabled: true,
              ),
            ),
          ),
          // List Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Parking Locations (${filteredParkingPlaces.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                if (_isSearching)
                  Text(
                    'Search Results',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          // Parking List
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 2,
            ),
            SizedBox(height: 16),
            Text(
              'Finding parking places in Patna...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: fetchParkingPlaces,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredParkingPlaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No parking places found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                searchController.clear();
                _filterParkingPlaces('');
              },
              child: const Text('Show All Parking'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredParkingPlaces.length,
      itemBuilder: (context, index) {
        final place = filteredParkingPlaces[index];
        return _buildParkingCard(place, index);
      },
    );
  }

  Widget _buildParkingCard(Map<String, dynamic> place, int index) {
    final rating = place['rating']?.toDouble() ?? 0.0;
    final isOpen = place['opening_hours']?['open_now'] ?? false;
    final distance = _calculateDistance(place);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.parkingCard.withValues(alpha: 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _zoomToLocation(
            LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            ),
          );
          _showParkingDetails(place, index);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Parking Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_parking,
                  color: Colors.blue[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown Parking',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place['vicinity'] ?? 'No address available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Rating
                        if (rating > 0) ...[
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        // Distance
                        if (distance != null) ...[
                          Icon(Icons.place, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        // Open Status
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isOpen ? 'OPEN' : 'CLOSED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isOpen ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Navigation Icon
              IconButton(
                onPressed: () {
                  _zoomToLocation(
                    LatLng(
                      place['geometry']['location']['lat'],
                      place['geometry']['location']['lng'],
                    ),
                  );
                },
                icon: Icon(Icons.navigation, color: Colors.blue[700]),
                tooltip: 'Navigate to location',
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _calculateDistance(Map<String, dynamic> place) {
    if (_currentPosition == null) return null;

    final double startLat = _currentPosition!.latitude;
    final double startLng = _currentPosition!.longitude;
    final double endLat = place['geometry']['location']['lat'];
    final double endLng = place['geometry']['location']['lng'];

    return _calculateDistanceBetween(startLat, startLng, endLat, endLng);
  }

  double _calculateDistanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const double earthRadius = 6371;

    double dLat = _toRadians(endLat - startLat);
    double dLng = _toRadians(endLng - startLng);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}
