import 'package:flutter/material.dart';
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

    // Current line color for smooth transition after interchange
    Color currentLineColor =
    redLine.contains(route[0]) ? Colors.red : Colors.blue;

    // Hindi mapping (optional)
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${route.first} - ${route.last}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
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
                itemCount: route.length,
                itemBuilder: (context, index) {
                  final stationName = route[index];
                  final isInterchange =
                      stationName == "Patna Junction" ||
                          stationName == "Khemni Chak";

                  // Interchange ke baad line color switch
                  if (isInterchange && index != 0) {
                    currentLineColor =
                    currentLineColor == Colors.red ? Colors.blue : Colors.red;
                  }

                  final Map<String, dynamic> station = {
                    'name': stationName,
                    'hindi': hindiMap[stationName] ?? '',
                    'interchange': isInterchange,
                  };

                  return StationTile(
                    station: station,
                    index: index,
                    totalStations: totalStations,
                    lineColor: currentLineColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
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
          // ===== Left Line & Circle =====
          Column(
            children: [
              if (index > 0)
                Container(
                  width: 2,
                  height: 20,
                  color: lineColor.withOpacity(0.4),
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
                    ? const Icon(Icons.compare_arrows_rounded,
                    size: 16, color: Colors.white)
                    : null,
              ),
              if (index < totalStations - 1)
                Container(
                  width: 2,
                  height: 3.h,
                  color: lineColor.withOpacity(0.4),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // ===== Station Card =====
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station['name'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (isStart || isEnd)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isStart ? Colors.green[50] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isStart
                                  ? Colors.green[300]!
                                  : Colors.blue[300]!,
                            ),
                          ),
                          child: Text(
                            isStart ? 'START' : 'END',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isStart
                                  ? Colors.green[700]!
                                  : Colors.blue[700]!,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station['hindi'] ?? '',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  if (isInterchange) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.compare_arrows,
                              size: 12, color: Colors.orange[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Interchange Station',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
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
