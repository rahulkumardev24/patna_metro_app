import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RouteDetailsScreen extends StatelessWidget {
  final List<String> route;
  final int totalStops;
  final int time;
  final int fare;
  final List<String> redLine;
  final List<String> blueLine;

  const RouteDetailsScreen({
    super.key,
    required this.route,
    required this.totalStops,
    required this.time,
    required this.fare,
    required this.redLine,
    required this.blueLine,
  });

  @override
  Widget build(BuildContext context) {
    final totalStations = route.length;

    // Step 1: Precompute each station's line color once
    List<Color> stationColors = [];
    Color currentLineColor = redLine.contains(route[0])
        ? Colors.red
        : Colors.blue;

    for (int i = 0; i < totalStations; i++) {
      final stationName = route[i];
      bool isInterchange =
          stationName == "Patna Junction" || stationName == "Khemni Chak";

      stationColors.add(currentLineColor);

      // Interchange ke baad next color change hoga (next stations ke liye)
      if (isInterchange) {
        currentLineColor = currentLineColor == Colors.red
            ? Colors.blue
            : Colors.red;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
        ),
        title: Text(
          "${route.first} - ${route.last}",
          style: appTextStyle16(fontColor: Colors.white),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSummary(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: totalStations,
                itemBuilder: (context, index) {
                  final stationName = route[index];
                  final isInterchange =
                      stationName == "Patna Junction" ||
                      stationName == "Khemni Chak";

                  final Map<String, dynamic> station = {
                    'name': stationName,
                    'hindi': _getHindiName(stationName),
                    'interchange': isInterchange,
                  };

                  return StationTile(
                    station: station,
                    index: index,
                    totalStations: totalStations,
                    lineColor: stationColors[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHindiName(String english) {
    final Map<String, String> hindiMap = {
      "Danapur Cantonment": "दानापुर कैंट",
      "Saguna More": "सगुना मोड़",
      "Patna Junction": "पटना जंक्शन",
      "Khemni Chak": "खे़मनी चक",
      "Gandhi Maidan": "गांधी मैदान",
      "Akashvani": "आकाशवाणी",
      "PMCH": "पीएमसीएच",
      "Patna Science College": "पटना साइंस कॉलेज",
      "Moin-ul-Haq Stadium": "मोइन-उल-हक स्टेडियम",
      "Rajendra Nagar": "राजेंद्र नगर",
      "Malahi Pakri": "मलाही पकरी",
      "Bhootnath": "भूतनाथ",
      "Zero Mile": "जीरो माइल",
      "New ISBT": "न्यू आईएसबीटी",
      "Patliputra": "पटलीपुत्र",
      "Rukanpura": "रुकनपुरा",
      "Raja Bazar": "राजा बाजार",
      "Patna Zoo": "पटना चिड़ियाघर",
      "Vikas Bhawan": "विकास भवन",
      "Vidyut Bhawan": "विद्युत भवन",
      "Mithapur": "मिथापुर",
      "Ramkrishna Nagar": "रामकृष्ण नगर",
      "Jaganpura": "जगनपुरा",
    };
    return hindiMap[english] ?? '';
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(Icons.alt_route, 'Stops', '$totalStops'),
          _summaryItem(Icons.access_time, 'Time', '$time min'),
          _summaryItem(Icons.currency_rupee, 'Fare', '₹$fare'),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal),
        Text(title, style: appTextStyle12(fontColor: Colors.grey)),
        Text(
          value,
          style: appTextStyle16(
            fontWeight: FontWeight.bold,
            fontColor: Colors.teal,
          ),
        ),
      ],
    );
  }
}

class StationTile extends StatelessWidget {
  final Map<String, dynamic> station;
  final int index;
  final int totalStations;
  final Color lineColor;

  const StationTile({
    super.key,
    required this.station,
    required this.index,
    required this.totalStations,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isStart = index == 0;
    bool isEnd = index == totalStations - 1;
    bool isInterchange = station['interchange'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (index > 0)
                Container(
                  width: 2,
                  height: 20,
                  color: lineColor.withValues(alpha: 0.4),
                ),
              Container(
                width: 3.h,
                height: 3.h,
                decoration: BoxDecoration(
                  color: _getStationColor(isStart, isEnd, isInterchange),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isInterchange
                    ? const Icon(
                        Icons.compare_arrows_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (index < totalStations - 1)
                Container(
                  width: 2,
                  height: 3.h,
                  color: lineColor.withValues(alpha: 0.4),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station['name'],
                    style: appTextStyle16(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station['hindi'] ?? '',
                    style: appTextStyle15(
                      fontWeight: FontWeight.w500,
                      fontColor: Colors.black87,
                    ),
                  ),
                  if (isInterchange)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.compare_arrows,
                            size: 14,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Interchange Station',
                            style: appTextStyle12(
                              fontColor: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStationColor(bool isStart, bool isEnd, bool isInterchange) {
    if (isStart) return Colors.green;
    if (isEnd) return Colors.blue;
    if (isInterchange) return Colors.orange;
    return lineColor;
  }
}
