import 'package:flutter/material.dart';
import 'package:patna_metro/screen/emergency_contacts_screen.dart';
import 'package:patna_metro/screen/parking_place_screen.dart';
import 'package:patna_metro/screen/red_line_screen.dart';
import 'package:patna_metro/screen/route_find_screen.dart';
import 'package:patna_metro/screen/station_list_screen.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_constant.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../provider/app_state.dart';
import '../widgets/app_drawer.dart';
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

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
      backgroundColor: Colors.white,

      /// ----- Appbar ----- ///
      appBar: AppBar(
        title: Text(
          'Patna Metro',
          style: appTextStyle22(
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu_rounded, color: Colors.white, size: 22.sp),
        ),
      ),
      drawer: AppDrawer(),
      key: _key,

      /// ------ body ----- ///
      body: state.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.primaryColor,
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
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  _buildWelcomeHeader(),
                  SizedBox(height: 1.h),

                  /// ---- Quick Actions Grid --- ///
                  Text(
                    'Quick Actions',
                    style: appTextStyle20(
                      fontWeight: FontWeight.bold,
                      fontColor: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  /// ---- line ----- ///
                  SizedBox(
                    height: 36.w,
                    child: GridView.builder(
                      itemCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 3,
                        crossAxisSpacing: 1.h,
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
                                  style: appTextStyle18(
                                    fontColor: Colors.white,
                                  ),
                                ),

                                Text(
                                  myLine['subtitle'],
                                  style: appTextStyle15(
                                    fontColor: Colors.white70,
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
          colors: [Colors.yellow.shade700, Colors.yellow],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Patna Metro',
            style: appTextStyle20(fontWeight: FontWeight.bold),
          ),
          Text(
            'Smart, Fast & Convenient Travel',
            style: appTextStyle16(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.h),

          /// ------ Info section ---- ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCard(
                icon: Icons.train_rounded,
                subTitle: "Metro line",
                title: "2",
                iconColor: AppColor.primaryColor,
              ),

              _buildInfoCard(
                title: "25",
                subTitle: "Station",
                icon: Icons.location_on_rounded,
                iconColor: Colors.red,
              ),

              _buildInfoCard(
                title: "32 km",
                subTitle: "Total length",
                icon: Icons.route_rounded,
                iconColor: Colors.blue,
              ),

              _buildInfoCard(
                title: "2",
                subTitle: "Interchange",
                icon: Icons.compare_arrows_rounded,
                iconColor: Colors.yellow.shade900,
              ),
            ],
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
      ),
      children: [
        _buildQuickActionCard(
          title: 'Route Find',
          imagePath: AppConstant.route,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RouteFindScreen()),
          ),
        ),

        _buildQuickActionCard(
          title: 'Calculate Fare',
          imagePath: AppConstant.rupees,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FareCalculatorScreen()),
          ),
        ),
        _buildQuickActionCard(
          title: 'Route Map',
          imagePath: AppConstant.routeMap,
          onTap: () => Navigator.push(
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
          title: "Parking Place",
          imagePath: AppConstant.parking,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParkingPlaceScreen()),
          ),
        ),

        _buildQuickActionCard(
          title: 'Stations',
          imagePath: AppConstant.station,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StationListScreen()),
          ),
        ),

        _buildQuickActionCard(
          title: "Emergency Contacts",
          imagePath: AppConstant.emergency,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmergencyContactsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
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
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(imagePath, height: 15.w, fit: BoxFit.cover),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: appTextStyle16(
                  fontWeight: FontWeight.w800,
                  fontColor: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        /// ----- Icons -------- ///
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(icon, color: iconColor),
          ),
        ),
        SizedBox(height: 0.5.h),

        /// ----- title ----- ///
        Text(title, style: appTextStyle18(fontWeight: FontWeight.w900)),

        /// ---- subtitle ----- ///
        Text(subTitle, style: appTextStyle15()),
      ],
    );
  }
}
