import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:patna_metro/provider/app_state.dart';
import 'package:patna_metro/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'models/station.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final cachedJson = prefs.getString('stations_cache');

  final List<Station> initialStations = cachedJson != null
      ? (jsonDecode(cachedJson) as List)
            .map((e) => Station.fromJson(e as Map<String, dynamic>))
            .toList()
      : [];

  runApp(MyApp(initialStations: initialStations));
}

class MyApp extends StatelessWidget {
  final List<Station> initialStations;
  const MyApp({super.key, required this.initialStations});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(initialStations),
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Patna Metro',
            theme: ThemeData(primarySwatch: Colors.indigo),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

// Rest of the code remains same...

List<String> planRoute(Station from, Station to, List<Station> all) {
  final fromIndex = all.indexWhere((s) => s.id == from.id);
  final toIndex = all.indexWhere((s) => s.id == to.id);
  if (fromIndex == -1 || toIndex == -1) return [];
  if (fromIndex <= toIndex)
    return all.sublist(fromIndex, toIndex + 1).map((s) => s.name).toList();
  return all
      .sublist(toIndex, fromIndex + 1)
      .reversed
      .map((s) => s.name)
      .toList();
}

class FareService {
  static int estimateFare(int stops) {
    if (stops <= 3) return 15;
    final extra = ((stops - 3) / 3).ceil();
    return 15 + extra * 5;
  }
}
