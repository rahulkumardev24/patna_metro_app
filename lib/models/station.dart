class Station {
  final int id;
  final String name;
  final String code;
  final String type;
  final String line;
  final double? lat;
  final double? lng;
  final String opening;

  Station({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.line,
    this.lat,
    this.lng,
    required this.opening,
  });

  factory Station.fromJson(Map<String, dynamic> j) {
    return Station(
      id: j['id'] ?? 0,
      name: j['name'] ?? '',
      code: j['code'] ?? '',
      type: j['type'] ?? '',
      line: j['line'] ?? '',
      lat: j['lat'] == null ? null : (j['lat'] as num).toDouble(),
      lng: j['lng'] == null ? null : (j['lng'] as num).toDouble(),
      opening: j['opening'] ?? '',
    );
  }
}
