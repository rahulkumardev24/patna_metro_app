import 'package:flutter/material.dart';
import 'route_details_screen.dart';

class AppColor {
  static const Color primaryColor = Colors.teal;
}

class RouteFindScreen extends StatefulWidget {
  const RouteFindScreen({super.key});

  @override
  State<RouteFindScreen> createState() => _RouteFindScreenState();
}

class _RouteFindScreenState extends State<RouteFindScreen> {
  String? _selectedSource;
  String? _selectedDestination;

  final List<String> _redLine = [
    "Danapur Cantonment",
    "Saguna More",
    "RPS More",
    "Patliputra",
    "Rukanpura",
    "Raja Bazar",
    "Patna Zoo",
    "Vikas Bhawan",
    "Vidyut Bhawan",
    "Patna Junction",
    "Mithapur",
    "Ramkrishna Nagar",
    "Jaganpura",
    "Khemni Chak",
  ];

  final List<String> _blueLine = [
    "Patna Junction",
    "Akashvani",
    "Gandhi Maidan",
    "PMCH",
    "Patna Science College",
    "Moin-ul-Haq Stadium",
    "Rajendra Nagar",
    "Malahi Pakri",
    "Khemni Chak",
    "Bhootnath",
    "Zero Mile",
    "New ISBT",
  ];

  final List<String> _interchanges = ["Patna Junction", "Khemni Chak"];

  /// 🛤 Shortest Route Calculation
  List<String> _calculateRoute(String source, String destination) {
    bool sourceInRed = _redLine.contains(source);
    bool destInRed = _redLine.contains(destination);
    bool sourceInBlue = _blueLine.contains(source);
    bool destInBlue = _blueLine.contains(destination);

    List<List<String>> possibleRoutes = [];

    // 🚆 1. Same line Red
    if (sourceInRed && destInRed) {
      int s = _redLine.indexOf(source);
      int d = _redLine.indexOf(destination);
      possibleRoutes.add(
        (s <= d)
            ? _redLine.sublist(s, d + 1)
            : _redLine.sublist(d, s + 1).reversed.toList(),
      );
    }

    // 🚆 2. Same line Blue
    if (sourceInBlue && destInBlue) {
      int s = _blueLine.indexOf(source);
      int d = _blueLine.indexOf(destination);
      possibleRoutes.add(
        (s <= d)
            ? _blueLine.sublist(s, d + 1)
            : _blueLine.sublist(d, s + 1).reversed.toList(),
      );
    }

    // 🚆 3. Different line via each interchange
    for (String interchange in _interchanges) {
      if ((sourceInRed && destInBlue) || (sourceInBlue && destInRed)) {
        // --- Source se interchange tak ---
        List<String> part1 = [];
        if (sourceInRed) {
          int s = _redLine.indexOf(source);
          int i = _redLine.indexOf(interchange);
          if (i != -1) {
            part1 = (s <= i)
                ? _redLine.sublist(s, i + 1)
                : _redLine.sublist(i, s + 1).reversed.toList();
          }
        } else {
          int s = _blueLine.indexOf(source);
          int i = _blueLine.indexOf(interchange);
          if (i != -1) {
            part1 = (s <= i)
                ? _blueLine.sublist(s, i + 1)
                : _blueLine.sublist(i, s + 1).reversed.toList();
          }
        }

        // --- Interchange se destination tak ---
        List<String> part2 = [];
        if (destInRed) {
          int d = _redLine.indexOf(destination);
          int i = _redLine.indexOf(interchange);
          if (i != -1) {
            part2 = (i <= d)
                ? _redLine.sublist(i, d + 1)
                : _redLine.sublist(d, i + 1).reversed.toList();
          }
        } else {
          int d = _blueLine.indexOf(destination);
          int i = _blueLine.indexOf(interchange);
          if (i != -1) {
            part2 = (i <= d)
                ? _blueLine.sublist(i, d + 1)
                : _blueLine.sublist(d, i + 1).reversed.toList();
          }
        }

        if (part1.isNotEmpty && part2.isNotEmpty) {
          possibleRoutes.add([...part1, ...part2.skip(1)]);
        }
      }
    }

    // 🟢 Return shortest route
    possibleRoutes.sort((a, b) => a.length.compareTo(b.length));
    return possibleRoutes.isNotEmpty ? possibleRoutes.first : [];
  }

  void _findRoute() {
    if (_selectedSource == null || _selectedDestination == null) return;

    final route = _calculateRoute(_selectedSource!, _selectedDestination!);

    final totalStops = route.length - 1;
    final estimatedTime = totalStops * 3;
    final estimatedFare = _calculateFare(totalStops);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          route: route,
          totalStops: totalStops,
          time: estimatedTime,
          fare: estimatedFare,
          redLine: _redLine,
          blueLine: _blueLine,
        ),
      ),
    );
  }

  int _calculateFare(int stops) {
    if (stops <= 5) return 10;
    if (stops <= 10) return 20;
    if (stops <= 15) return 30;
    return 40;
  }

  void _swapStations() {
    setState(() {
      final temp = _selectedSource;
      _selectedSource = _selectedDestination;
      _selectedDestination = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allStations = {..._redLine, ..._blueLine}.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'Patna Metro Route Finder',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSource,
              hint: const Text('Select source station'),
              items: allStations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSource = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _swapStations,
              child: const CircleAvatar(
                backgroundColor: AppColor.primaryColor,
                child: Icon(Icons.swap_vert, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDestination,
              hint: const Text('Select destination station'),
              items: allStations
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedDestination = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed:
                    (_selectedSource == null || _selectedDestination == null)
                    ? null
                    : _findRoute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                ),
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text(
                  'FIND SHORTEST ROUTE',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
