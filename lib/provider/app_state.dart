import 'dart:convert';

import 'package:flutter/cupertino.dart' show ChangeNotifier ;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/station.dart';

class AppState extends ChangeNotifier {
  List<Station> stations;
  bool isHindi = false;
  bool isLoading = false;

  AppState(this.stations);

  Future<void> toggleLanguage() async {

    isHindi = !isHindi;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isHindi', isHindi);
  }

  Future<void> fetchStations() async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse('https://mypatnametro.com/api/stations');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        stations = data.map((e) => Station.fromJson(e)).toList();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('stations_cache', jsonEncode(data));
      }
    } catch (e) {
      print('Failed to fetch stations: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Station? getStationById(int id) =>
      stations.firstWhere((s) => s.id == id, orElse: () => stations.first);
}


