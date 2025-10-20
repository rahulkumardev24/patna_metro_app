import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/metro_info_card.dart';
import '../widgets/search_station.dart';
import '../widgets/station_tile.dart';

class RedLineScreen extends StatefulWidget {
  const RedLineScreen({super.key});

  @override
  State<RedLineScreen> createState() => _RedLineScreenState();
}

class _RedLineScreenState extends State<RedLineScreen> {
  final List<Map<String, dynamic>> redLineStations = [
    {
      "name": "Danapur Cantonment",
      "hindi": "दानापुर छावनी",
      "interchange": false,
    },
    {"name": "Saguna More", "hindi": "सगुना मोड़", "interchange": false},
    {"name": "RPS More", "hindi": "आर पी एस मोड़", "interchange": false},
    {"name": "Patliputra", "hindi": "पाटलिपुत्र", "interchange": false},
    {"name": "Rukanpura", "hindi": "रुकनपुरा", "interchange": false},
    {"name": "Raja Bazar", "hindi": "राजा बाजार", "interchange": false},
    {"name": "Patna Zoo", "hindi": "पटना चिड़ियाघर", "interchange": false},
    {"name": "Vikas Bhawan", "hindi": "विकास भवन", "interchange": false},
    {"name": "Vidyut Bhawan", "hindi": "विद्युत भवन", "interchange": false},
    {"name": "Patna Junction", "hindi": "पटना जंक्शन", "interchange": true},
    {"name": "Mithapur", "hindi": "मीठापुर", "interchange": false},
    {"name": "Ramkrishna Nagar", "hindi": "रामकृष्ण नगर", "interchange": false},
    {"name": "Jaganpura", "hindi": "जगनपुरा", "interchange": false},
    {"name": "Khemni Chak", "hindi": "खेमनीचक", "interchange": true},
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
        children: [
          const Text(
            'Red Line',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.primaryColor,
      elevation: 0,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: _searchStations),
      ],
    );
  }

  /// -------- Widgets ----- ///

  Widget _buildListView() {
    return Column(
      children: [
        MetroInfoCard(
          lineColor: Colors.red,
          title: 'Danapur to Khemni Chak',
          distance: '14.5',
          fare: '40',
          time: '25',
          stations: '14',
          interchange: '2',
        ),

        // Station List
        Expanded(
          child: ListView.builder(
            itemCount: redLineStations.length,
            itemBuilder: (context, index) {
              return StationTile(
                station: redLineStations[index],
                index: index,
                totalStations: redLineStations.length,
                lineColor: Colors.red,
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
      delegate: StationSearchDelegate(redLineStations),
    );
  }
}
