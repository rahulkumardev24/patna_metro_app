import 'package:flutter/material.dart';
import 'package:patna_metro/models/station.dart';
import 'package:patna_metro/screen/station_detail_screen.dart';
import 'package:patna_metro/utils/app_constant.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_text_style.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  _StationListScreenState createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  String _selectedLine = 'All';
  String _selectedType = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  List<Station> get _allStations {
    final allStations = <Station>[];
    int idCounter = 1;

    /// Add Red Line stations
    for (final station in AppConstant.redLineStations) {
      allStations.add(
        Station(
          id: idCounter++,
          name: station['name'] as String,
          code: _generateStationCode(station['name'] as String),
          type: station['interchange'] ? 'Interchange' : 'Regular',
          line: 'Red Line',
          lat: null,
          lng: null,
          opening: '2024',
        ),
      );
    }

    // Add Blue Line stations (avoid duplicates for interchange stations)
    for (final station in AppConstant.blueLineStations) {
      if (!allStations.any((s) => s.name == station['name'])) {
        allStations.add(
          Station(
            id: idCounter++,
            name: station['name'] as String,
            code: _generateStationCode(station['name'] as String),
            type: station['interchange'] ? 'Interchange' : 'Regular',
            line: 'Blue Line',
            lat: null,
            lng: null,
            opening: '2024',
          ),
        );
      }
    }

    return allStations;
  }

  String _generateStationCode(String stationName) {
    final words = stationName.split(' ');
    if (words.length == 1) return words[0].substring(0, 2).toUpperCase();

    String code = '';
    for (final word in words) {
      if (word.isNotEmpty &&
          !['the', 'and', 'of'].contains(word.toLowerCase())) {
        code += word[0].toUpperCase();
      }
    }
    return code.length > 3 ? code.substring(0, 3) : code;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter stations based on selections
    final filteredStations = _allStations.where((station) {
      final matchesLine =
          _selectedLine == 'All' || station.line == _selectedLine;
      final matchesType =
          _selectedType == 'All' || station.type == _selectedType;
      final matchesSearch =
          _searchQuery.isEmpty ||
          station.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          station.code.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesLine && matchesType && matchesSearch;
    }).toList();

    // Get unique lines and types for filters
    final lines = ['All', 'Red Line', 'Blue Line'];
    final types = ['All', 'Regular', 'Interchange'];

    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// ---- App bar ---- ///
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patna Metro Stations',
              style: appTextStyle18(
                fontColor: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${filteredStations.length} stations found',
              style: appTextStyle12(fontColor: Colors.white70),
            ),
          ],
        ),
        elevation: 0,
      ),

      /// --------- Body ------- ///
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(lines, types),

          // Stations List
          Expanded(child: _buildStationsList(filteredStations)),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection(List<String> lines, List<String> types) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by station name or code...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          SizedBox(height: 12),

          // Filter Row
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedLine,
                  items: lines,
                  hint: 'Select Line',
                  icon: Icons.train,
                  onChanged: (value) {
                    setState(() {
                      _selectedLine = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedType,
                  items: types,
                  hint: 'Select Type',
                  icon: Icons.category,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              _buildClearFiltersButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColor.primaryColor),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: appTextStyle14(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton() {
    return Tooltip(
      message: 'Clear all filters',
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLine = 'All';
            _selectedType = 'All';
            _searchQuery = '';
            _searchController.clear();
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Icon(Icons.filter_alt_off, color: Colors.grey[600], size: 20),
        ),
      ),
    );
  }

  Widget _buildStationsList(List<Station> filteredStations) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      );
    }

    if (filteredStations.isEmpty) {
      return _buildNoResultsState();
    }

    return ListView.builder(
      itemCount: filteredStations.length,
      itemBuilder: (context, index) {
        final station = filteredStations[index];
        return _buildStationCard(station);
      },
    );
  }

  Widget _buildNoResultsState() {
    return ListView(
      children: [
        SizedBox(height: 80),
        Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
        SizedBox(height: 20),
        Text(
          'No Stations Found',
          textAlign: TextAlign.center,
          style: appTextStyle18(
            fontWeight: FontWeight.w600,
            fontColor: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Try adjusting your search or filters',
            textAlign: TextAlign.center,
            style: appTextStyle14(fontColor: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildStationCard(Station station) {
    Color lineColor = station.line == 'Red Line' ? Colors.red : Colors.blue;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StationDetailScreen(station: station),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Station Code Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: lineColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lineColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      station.code,
                      style: appTextStyle12(
                        fontWeight: FontWeight.bold,
                        fontColor: lineColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: 20,
                      height: 4,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16),

              // Station Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: appTextStyle16(
                        fontWeight: FontWeight.w600,
                        fontColor: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        /// Line
                        _buildChip(station.line, lineColor),
                        SizedBox(width: 8),

                        /// Interchange
                        station.type == 'Interchange'
                            ? _buildChip(station.type, Colors.orange)
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),

              /// Navigation Icon
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: appTextStyle11(fontWeight: FontWeight.w500, fontColor: color),
      ),
    );
  }
}
