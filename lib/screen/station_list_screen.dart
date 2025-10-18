import 'package:flutter/material.dart';
import 'package:patna_metro/screen/station_detail_screen.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';

class StationListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Stations (${state.stations.length})')),
      body: RefreshIndicator(
        onRefresh: () => state.fetchStations(),
        child: state.stations.isEmpty
            ? ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('No stations found. Pull to refresh.'),
              ),
            ),
          ],
        )
            : ListView.builder(
          itemCount: state.stations.length,
          itemBuilder: (_, i) {
            final st = state.stations[i];
            return ListTile(
              leading: CircleAvatar(child: Text(st.code)),
              title: Text(st.name),
              subtitle: Text(
                '${st.line} • ${st.type} • Opens: ${st.opening}',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StationDetailScreen(station: st),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}