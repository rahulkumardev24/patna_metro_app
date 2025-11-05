import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patna_metro/utils/app_constant.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../utils/app_color.dart';

class FareCalculatorScreen extends StatefulWidget {
  const FareCalculatorScreen({super.key});

  @override
  State<FareCalculatorScreen> createState() => _FareCalculatorScreenState();
}

class _FareCalculatorScreenState extends State<FareCalculatorScreen> {
  String? _selectedSource;
  String? _selectedDestination;
  int _calculatedFare = 0;
  int _totalStops = 0;

  final List<Map<String, dynamic>> _redLine = AppConstant.redLineStations;
  final List<Map<String, dynamic>> _blueLine = AppConstant.blueLineStations;
  final List<String> _interchanges = ["Patna Junction", "Khemni Chak"];

  /// 🛤 Route Calculation (same as your existing function)
  List<String> _calculateRoute(String source, String destination) {
    bool sourceInRed = _redLine.any((s) => s['name'] == source);
    bool destInRed = _redLine.any((s) => s['name'] == destination);
    bool sourceInBlue = _blueLine.any((s) => s['name'] == source);
    bool destInBlue = _blueLine.any((s) => s['name'] == destination);

    List<List<String>> possibleRoutes = [];

    // 1. Same line Red
    if (sourceInRed && destInRed) {
      int s = _redLine.indexWhere((e) => e['name'] == source);
      int d = _redLine.indexWhere((e) => e['name'] == destination);
      possibleRoutes.add(
        (s <= d)
            ? _redLine
                  .sublist(s, d + 1)
                  .map((e) => e['name'] as String)
                  .toList()
            : _redLine
                  .sublist(d, s + 1)
                  .reversed
                  .map((e) => e['name'] as String)
                  .toList(),
      );
    }

    // 2. Same line Blue
    if (sourceInBlue && destInBlue) {
      int s = _blueLine.indexWhere((e) => e['name'] == source);
      int d = _blueLine.indexWhere((e) => e['name'] == destination);
      possibleRoutes.add(
        (s <= d)
            ? _blueLine
                  .sublist(s, d + 1)
                  .map((e) => e['name'] as String)
                  .toList()
            : _blueLine
                  .sublist(d, s + 1)
                  .reversed
                  .map((e) => e['name'] as String)
                  .toList(),
      );
    }

    // 3. Different line via each interchange
    for (String interchange in _interchanges) {
      if ((sourceInRed && destInBlue) || (sourceInBlue && destInRed)) {
        // --- Source to interchange ---
        List<String> part1 = [];
        if (sourceInRed) {
          int s = _redLine.indexWhere((e) => e['name'] == source);
          int i = _redLine.indexWhere((e) => e['name'] == interchange);
          if (i != -1) {
            part1 = (s <= i)
                ? _redLine
                      .sublist(s, i + 1)
                      .map((e) => e['name'] as String)
                      .toList()
                : _redLine
                      .sublist(i, s + 1)
                      .reversed
                      .map((e) => e['name'] as String)
                      .toList();
          }
        } else {
          int s = _blueLine.indexWhere((e) => e['name'] == source);
          int i = _blueLine.indexWhere((e) => e['name'] == interchange);
          if (i != -1) {
            part1 = (s <= i)
                ? _blueLine
                      .sublist(s, i + 1)
                      .map((e) => e['name'] as String)
                      .toList()
                : _blueLine
                      .sublist(i, s + 1)
                      .reversed
                      .map((e) => e['name'] as String)
                      .toList();
          }
        }

        // --- Interchange to destination ---
        List<String> part2 = [];
        if (destInRed) {
          int d = _redLine.indexWhere((e) => e['name'] == destination);
          int i = _redLine.indexWhere((e) => e['name'] == interchange);
          if (i != -1) {
            part2 = (i <= d)
                ? _redLine
                      .sublist(i, d + 1)
                      .map((e) => e['name'] as String)
                      .toList()
                : _redLine
                      .sublist(d, i + 1)
                      .reversed
                      .map((e) => e['name'] as String)
                      .toList();
          }
        } else {
          int d = _blueLine.indexWhere((e) => e['name'] == destination);
          int i = _blueLine.indexWhere((e) => e['name'] == interchange);
          if (i != -1) {
            part2 = (i <= d)
                ? _blueLine
                      .sublist(i, d + 1)
                      .map((e) => e['name'] as String)
                      .toList()
                : _blueLine
                      .sublist(d, i + 1)
                      .reversed
                      .map((e) => e['name'] as String)
                      .toList();
          }
        }

        if (part1.isNotEmpty && part2.isNotEmpty) {
          possibleRoutes.add([...part1, ...part2.skip(1)]);
        }
      }
    }

    // 🟢 Return shortest route
    possibleRoutes.sort((a, b) => a.length.compareTo(b.length));
    return possibleRoutes.isNotEmpty ? possibleRoutes.first : [];
  }

  /// 🎫 Fare Calculation
  int _calculateFare(int stops) {
    if (stops <= 5) return 10;
    if (stops <= 10) return 20;
    if (stops <= 15) return 30;
    return 40;
  }

  /// Calculate Fare and Details
  void _calculateFareDetails() {
    if (_selectedSource == null || _selectedDestination == null) return;

    // Extract English name from dropdown selection (English (Hindi))
    final sourceName = _selectedSource!.split(" (")[0];
    final destName = _selectedDestination!.split(" (")[0];

    final route = _calculateRoute(sourceName, destName);

    if (route.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No route found between selected stations'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _totalStops = route.length - 1;
      _calculatedFare = _calculateFare(_totalStops);
    });
  }

  ///  Swap Stations
  void _swapStations() {
    setState(() {
      final temp = _selectedSource;
      _selectedSource = _selectedDestination;
      _selectedDestination = temp;

      // Recalculate if both stations are selected
      if (_selectedSource != null && _selectedDestination != null) {
        _calculateFareDetails();
      } else {
        _resetCalculation();
      }
    });
  }

  ///  Reset Calculation
  void _resetCalculation() {
    setState(() {
      _calculatedFare = 0;
      _totalStops = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dropdown list: "English (Hindi)"
    final allStations = ([
      ..._redLine.map((e) => "${e['name']} (${e['hindi']})"),
      ..._blueLine.map((e) => "${e['name']} (${e['hindi']})"),
    ].toSet().toList())..sort();

    return Scaffold(
      backgroundColor: Colors.white,

      /// ------- App bar ------- ///
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
        ),
        title: const Text(
          'Fare Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      /// ------- Body ----- ///
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station Selection Cards
            _buildStationSelectionCards(allStations),
            SizedBox(height: 2.h),

            // Calculate Fare Button
            _buildCalculateButton(),
            SizedBox(height: 2.h),

            // Results Section
            if (_calculatedFare > 0) _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStationSelectionCards(List<String> allStations) {
    return Column(
      children: [
        /// From Station Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: BoxBorder.all(width: 1, color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'FROM STATION',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedSource,
                hint: Text(
                  'Select starting station',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                items: allStations.map((station) {
                  return DropdownMenuItem(
                    value: station,
                    child: Text(
                      station,
                      style: appTextStyle16(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                    _resetCalculation();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                icon: Icon(Icons.arrow_drop_down, color: AppColor.primaryColor),
                isExpanded: true,
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        /// Swap Button
        GestureDetector(
          onTap: _swapStations,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.swap_vert, color: Colors.white, size: 22),
          ),
        ),

        SizedBox(height: 2.h),

        /// To Station Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: BoxBorder.all(width: 1, color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'TO STATION',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDestination,
                hint: Text(
                  'Select destination station',
                  style: appTextStyle14(fontColor: Colors.grey.shade500),
                ),
                items: allStations.map((station) {
                  return DropdownMenuItem(
                    value: station,
                    child: Text(
                      station,
                      style: appTextStyle16(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestination = value;
                    _resetCalculation();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                icon: Icon(Icons.arrow_drop_down, color: AppColor.primaryColor),
                isExpanded: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_selectedSource == null || _selectedDestination == null)
            ? null
            : _calculateFareDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Text(
              'Calculate Fare',
              style: appTextStyle16(
                fontWeight: FontWeight.w600,
                fontColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      width: double.infinity,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Row(
              children: [
                SizedBox(width: 12.w),

                /// ------- Ticket ------ ///
                RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    "TICKET",
                    style: GoogleFonts.nunito(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                      letterSpacing: 6,
                    ),
                  ),
                ),
                VerticalDivider(thickness: 2, color: Colors.black26),

                Padding(
                  padding: EdgeInsets.only(left: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Estimated Fare',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      Text(
                        '₹$_calculatedFare',
                        style: TextStyle(
                          fontSize: 27.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: -4.h,
            top: 0,
            child: Container(
              height: 21.h,
              width: 8.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -4.h,
            top: 0,
            child: Container(
              height: 21.h,
              width: 8.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
