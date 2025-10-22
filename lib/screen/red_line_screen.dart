import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_constant.dart';

import '../widgets/metro_info_card.dart';
import '../widgets/search_station.dart';
import '../widgets/station_tile.dart';

class RedLineScreen extends StatefulWidget {
  const RedLineScreen({super.key});

  @override
  State<RedLineScreen> createState() => _RedLineScreenState();
}

class _RedLineScreenState extends State<RedLineScreen> {
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
            itemCount: AppConstant.redLineStations.length,
            itemBuilder: (context, index) {
              return StationTile(
                station: AppConstant.redLineStations[index],
                index: index,
                totalStations: AppConstant.redLineStations.length,
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
      delegate: StationSearchDelegate(AppConstant.redLineStations),
    );
  }
}
