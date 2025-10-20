import 'package:flutter/material.dart';
import 'package:patna_metro/screen/blue_line_screen.dart';
import 'package:patna_metro/screen/red_line_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';
import '../models/station.dart';
import '../provider/app_state.dart';

class RouteFindScreen extends StatefulWidget {
  const RouteFindScreen({super.key});

  @override
  _RoutePlannerScreenState createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RouteFindScreen> {
  Station? from;
  Station? to;
  String? result;

  List<Map<String, dynamic>> line = [
    {
      'image': 'lib/assets/images/red_train.png',
      "title": "Red line",
      "subtitle": "East-West Line",
      "color": Colors.red.shade700,
      "station": "14",
    },
    {
      'image': 'lib/assets/images/blue_train.png',
      "title": "Blue line",
      "subtitle": "North-South Line",
      "color": Colors.blue.shade700,
      "station": "12",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      /// ------ Appbar ------ ///
      appBar: AppBar(title: Text('Route Planner')),

      /// ------ Body ---------- ///
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50.w,
              child: GridView.builder(
                itemCount: 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final myLine = line[index];
                  return GestureDetector(
                    onTap: (){
                      if( myLine['title'] == "Red line"){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> RedLineScreen()));

                      }else if(myLine['title'] == "Blue line"){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> BlueLineScreen()));
                      }

                    },
                    child: Card(
                      color: myLine['color'],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            myLine['image'],
                            height: 10.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 1.h),

                          Text(
                            myLine['title'],
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),

                          Text(
                            myLine['subtitle'],
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 21),

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
