import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/station.dart';
import '../provider/app_state.dart';

class RoutePlannerScreen extends StatefulWidget {
  @override
  _RoutePlannerScreenState createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen> {
  Station? from;
  Station? to;
  String? result;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Route Planner')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<Station>(
              decoration: InputDecoration(labelText: 'From'),
              items: state.stations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => from = v),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<Station>(
              decoration: InputDecoration(labelText: 'To'),
              items: state.stations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => to = v),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (from == null || to == null)
                  ? null
                  : () {
                      final route = planRoute(from!, to!, state.stations);
                      final fare = FareService.estimateFare(route.length);
                      setState(() {
                        result =
                            'Route: ${route.join(' → ')}\nStops: ${route.length}\nFare: ₹$fare\nTime: ${route.length * 3} mins';
                      });
                    },
              child: Text('Plan Route'),
            ),
            if (result != null)
              Padding(
                padding: EdgeInsets.all(12),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(result!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
