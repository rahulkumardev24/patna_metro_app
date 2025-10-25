import 'package:flutter/material.dart';
import 'package:patna_metro/screen/emergency_contacts_screen.dart';
import 'package:patna_metro/screen/parking_place_screen.dart';
import 'package:patna_metro/screen/red_line_screen.dart';
import 'package:patna_metro/screen/route_find_screen.dart';
import 'package:patna_metro/screen/station_list_screen.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_constant.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../provider/app_state.dart';
import 'blue_line_screen.dart';
import 'fare_calculator_screen.dart';
import 'metro_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> line = [
    {
      'image': 'lib/assets/images/red_train.png',
      "title": "Red line",
      "subtitle": "East-West Line",
      "color": Colors.red.shade700,
      "station": "14",
    },
    {
      'image': 'lib/assets/images/blue_train.png',
      "title": "Blue line",
      "subtitle": "North-South Line",
      "color": Colors.blue.shade700,
      "station": "12",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).fetchStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Patna Metro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Colors.white),
            onPressed: () => state.toggleLanguage(),
            tooltip: 'Change Language',
          ),
        ],
      ),
      body: state.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1a237e),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading Patna Metro...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  _buildWelcomeHeader(),
                  SizedBox(height: 1.h),

                  // Quick Actions Grid
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // ---- line ----- ///
                  SizedBox(
                    height: 36.w,
                    child: GridView.builder(
                      itemCount: 2,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 3,
                      ),
                      itemBuilder: (context, index) {
                        final myLine = line[index];
                        return GestureDetector(
                          onTap: () {
                            if (myLine['title'] == "Red line") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RedLineScreen(),
                                ),
                              );
                            } else if (myLine['title'] == "Blue line") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlueLineScreen(),
                                ),
                              );
                            }
                          },
                          child: Card(
                            color: myLine['color'],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  myLine['image'],
                                  height: 6.h,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 1.h),

                                Text(
                                  myLine['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                Text(
                                  myLine['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// --- Quick action ---- ///
                  _buildQuickActionsGrid(),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_subway, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Welcome to Patna Metro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Smart, Fast & Convenient Travel',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🚇 ${Provider.of<AppState>(context).stations.length} Stations Active',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: [
        _buildQuickActionCard(
          'Route Find',
          Icons.directions,
          Color(0xFF00c853),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RouteFindScreen()),
          ),
        ),
        _buildQuickActionCard(
          'Route Map',
          Icons.map,
          Color(0xFF1a237e),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MetroMapScreen(
                title: 'Patna Metro Route Map',
                imagePath: 'lib/assets/map/metro_map_1.png',
              ),
            ),
          ),
        ),

        _buildQuickActionCard(
          'Stations',
          Icons.location_city,
          Color(0xFFff6d00),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StationListScreen()),
          ),
        ),
        _buildQuickActionCard(
          'Calculate Fare',
          Icons.currency_rupee,
          Color(0xFFaa00ff),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FareCalculatorScreen()),
          ),
        ),

        _buildQuickActionCard(
          "Parking Place",
          Icons.currency_rupee,
          Color(0xFFaa00ff),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParkingPlaceScreen()),
          ),
        ),
        _buildQuickActionCard(
          "Emergency Contacts",
          Icons.currency_rupee,
          Color(0xFFaa00ff),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmergencyContactsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
