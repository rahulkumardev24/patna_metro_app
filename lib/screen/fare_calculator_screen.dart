import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/station.dart';
import '../provider/app_state.dart';

class FareCalculatorScreen extends StatefulWidget {
  @override
  _FareCalculatorScreenState createState() => _FareCalculatorScreenState();
}

class _FareCalculatorScreenState extends State<FareCalculatorScreen> {
  Station? from;
  Station? to;
  int? fare;
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Fare Calculator')),
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
            DropdownButtonFormField<Station>(
              decoration: InputDecoration(labelText: 'To'),
              items: state.stations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => to = v),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: (from == null || to == null)
                  ? null
                  : () {
                      final route = planRoute(from!, to!, state.stations);
                      setState(
                        () => fare = FareService.estimateFare(route.length),
                      );
                    },
              child: Text('Calculate Fare'),
            ),
            if (fare != null)
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Estimated Fare: ₹$fare'),
              ),
          ],
        ),
      ),
    );
  }
}
