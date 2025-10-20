import 'package:flutter/material.dart';
import '../widgets/metro_info_card.dart';
import '../widgets/search_station.dart';
import '../widgets/station_tile.dart';

class BlueLineScreen extends StatefulWidget {
  const BlueLineScreen({super.key});

  @override
  State<BlueLineScreen> createState() => _BlueLineScreenState();
}

class _BlueLineScreenState extends State<BlueLineScreen> {
  final List<Map<String, dynamic>> blueLineStations = [
    {
      "name": "Patna Junction",
      "hindi": "पटना जंक्शन",
      "interchange": true, // Interchange with Red Line
    },
    {"name": "Akashvani", "hindi": "आकाशवाणी", "interchange": false},
    {"name": "Gandhi Maidan", "hindi": "गांधी मैदान", "interchange": false},
    {"name": "PMCH", "hindi": "पीएमसीएच", "interchange": false},
    {"name": "Patna Science College", "hindi": "पटना साइंस कॉलेज", "interchange": false},
    {"name": "Moin-ul-Haq Stadium", "hindi": "मोइन-उल-हक स्टेडियम", "interchange": false},
    {"name": "Rajendra Nagar", "hindi": "राजेंद्र नगर", "interchange": false},
    {"name": "Malahi Pakri", "hindi": "मलाही पकड़ी", "interchange": true}, // Interchange with Red Line
    {"name": "Khemnichak", "hindi": "खेमनीचक", "interchange": false},
    {"name": "Bhootnath", "hindi": "भूतनाथ", "interchange": false},
    {"name": "Zero Mile", "hindi": "ज़ीरो माइल", "interchange": false},
    {
      "name": "New ISBT (Patliputra Bus Terminal)",
      "hindi": "न्यू आईएसबीटी (पाटलिपुत्र बस टर्मिनल)",
      "interchange": false,
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// ------- App bar ------ ///
      appBar: _buildAppBar(),
      body: _buildListView(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Blue Line',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      elevation: 0,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: _searchStations),
      ],
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        MetroInfoCard(
          lineColor: Colors.blue,
          title: 'Patna Junction to New ISBT',
          distance: '14.5',
          fare: '40',
          time: '25',
          stations: blueLineStations.length.toString(),
          interchange: '2',
        ),

        /// ------- Station List --------
        Expanded(
          child: ListView.builder(
            itemCount: blueLineStations.length,
            itemBuilder: (context, index) {
              return StationTile(
                station: blueLineStations[index],
                index: index,
                totalStations: blueLineStations.length,
                lineColor: Colors.blue,
              );
            },
          ),
        ),
      ],
    );
  }

  void _searchStations() {
    showSearch(
      context: context,
      delegate: StationSearchDelegate(blueLineStations),
    );
  }
}
