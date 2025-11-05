import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_text_style.dart';
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
              style: appTextStyle16(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Line: ${station.line}'),
            SizedBox(height: 8),
            Text('Type: ${station.type}'),
            SizedBox(height: 8),
            Text('Opening: ${station.opening}'),
            SizedBox(height: 12),
            Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
