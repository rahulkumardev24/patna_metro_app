import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_constant.dart';
import '../widgets/metro_info_card.dart';
import '../widgets/search_station.dart';
import '../widgets/station_tile.dart';

class BlueLineScreen extends StatefulWidget {
  const BlueLineScreen({super.key});

  @override
  State<BlueLineScreen> createState() => _BlueLineScreenState();
}

class _BlueLineScreenState extends State<BlueLineScreen> {
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
      title: Text(
        'Blue Line',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColor.primaryColor,
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
          stations: AppConstant.blueLineStations.length.toString(),
          interchange: '2',
        ),

        /// ------- Station List --------
        Expanded(
          child: ListView.builder(
            itemCount: AppConstant.blueLineStations.length,
            itemBuilder: (context, index) {
              return StationTile(
                station: AppConstant.blueLineStations[index],
                index: index,
                totalStations: AppConstant.blueLineStations.length,
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
      delegate: StationSearchDelegate(AppConstant.blueLineStations),
    );
  }
}
