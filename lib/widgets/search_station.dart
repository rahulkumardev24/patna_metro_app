import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_text_style.dart';

class StationSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> stations;

  StationSearchDelegate(this.stations);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Map<String, dynamic>> suggestionList = query.isEmpty
        ? stations
        : stations.where((station) {
            final name = station['name'].toString().toLowerCase();
            final code = station['code'].toString().toLowerCase();
            final searchQuery = query.toLowerCase();
            return name.contains(searchQuery) || code.contains(searchQuery);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final station = suggestionList[index];
        final stationIndex = stations.indexOf(station);
        final isStart = stationIndex == 0;
        final isEnd = stationIndex == stations.length - 1;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getStationColor(station, isStart, isEnd),
            child: Text(
              '${stationIndex + 1}',
              style: appTextStyle12(
                fontColor: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(station['name']),
          subtitle: Text('${station['code']} • ${station['type']}'),
          trailing: station['interchange']
              ? const Icon(Icons.compare_arrows, color: Colors.orange)
              : null,
          onTap: () {
            close(context, station);
          },
        );
      },
    );
  }

  Color _getStationColor(
    Map<String, dynamic> station,
    bool isStart,
    bool isEnd,
  ) {
    if (isStart) return Colors.green;
    if (isEnd) return Colors.blue;
    if (station['interchange']) return Colors.orange;
    return Colors.red;
  }
}
