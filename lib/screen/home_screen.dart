import 'package:flutter/material.dart';
import 'package:patna_metro/screen/parking_place_screen.dart';
import 'package:patna_metro/screen/route_find_screen.dart';
import 'package:patna_metro/screen/station_list_screen.dart';
import 'package:provider/provider.dart';
import '../provider/app_state.dart';
import 'fare_calculator_screen.dart';
import 'metro_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: Color(0xFF1a237e), // Deep indigo
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  _buildWelcomeHeader(),
                  SizedBox(height: 24),

                  // Quick Actions Grid
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildQuickActionsGrid(),
                  SizedBox(height: 24),

                  // Features Section
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildFeaturesList(),
                ],
              ),
            ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
          'Route Find',
          Icons.directions,
          Color(0xFF00c853),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RouteFindScreen()),
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
                  color: color.withOpacity(0.1),
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

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeatureTile(
          'Real-time Train Status',
          'Live train locations and timings',
          Icons.train,
          Color(0xFF2196f3),
          () {
            // Add live status functionality
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Live Status Coming Soon!')));
          },
        ),
        _buildFeatureTile(
          'Metro Smart Card',
          'Recharge and check balance',
          Icons.credit_card,
          Color(0xFF4caf50),
          () {
            // Add smart card functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Smart Card Feature Coming Soon!')),
            );
          },
        ),
        _buildFeatureTile(
          'Travel Guide',
          'Metro etiquette and tips',
          Icons.travel_explore,
          Color(0xFFff9800),
          () {
            // Add travel guide functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Travel Guide Coming Soon!')),
            );
          },
        ),
        _buildFeatureTile(
          'Emergency Contacts',
          'Important helpline numbers',
          Icons.emergency,
          Color(0xFFf44336),
          () {
            // Add emergency contacts functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Emergency Contacts Coming Soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_forward_ios, color: color, size: 14),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
