import 'package:flutter/material.dart';

import '../main.dart';
import '../models/station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;
  const StationDetailScreen({super.key, required this.station});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(station.name)),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code: ${station.code}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Line: ${station.line}'),
            SizedBox(height: 8),
            Text('Type: ${station.type}'),
            SizedBox(height: 8),
            Text('Opening: ${station.opening}'),
            SizedBox(height: 12),
            Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...station.amenities.map(
                  (a) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('• $a'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}