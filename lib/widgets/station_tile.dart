import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StationTile extends StatelessWidget {
  final Map<String, dynamic> station;
  final int index;
  final int totalStations;
  final Color lineColor;

  const StationTile({
    super.key,
    required this.station,
    required this.index,
    required this.totalStations,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isStart = index == 0;
    bool isEnd = index == totalStations - 1;
    bool isInterchange = station['interchange'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Left Line & Circle =====
          Column(
            children: [
              if (index > 0)
                Container(
                  width: 2,
                  height: 20,
                  color: lineColor.withValues(alpha: 0.4),
                ),

              Container(
                width: 3.h,
                height: 3.h,
                decoration: BoxDecoration(
                  color: _getStationColor(station, isStart, isEnd),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isInterchange
                    ? Icon(
                        Icons.compare_arrows_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),

              if (index < totalStations - 1)
                Container(
                  width: 2,
                  height: 3.h,
                  color: lineColor.withValues(alpha: 0.4),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // ===== Station Card =====
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isStart || isEnd)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isStart ? Colors.green[50] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isStart
                                  ? Colors.green[300]!
                                  : Colors.blue[300]!,
                            ),
                          ),
                          child: Text(
                            isStart ? 'START' : 'END',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isStart
                                  ? Colors.green[700]!
                                  : Colors.blue[700]!,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station['hindi'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  if (isInterchange) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.compare_arrows,
                            size: 12,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Interchange Station',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStationColor(
    Map<String, dynamic> station,
    bool isStart,
    bool isEnd,
  ) {
    if (isStart) return Colors.green;
    if (isEnd) return Colors.blue;
    if (station['interchange']) return Colors.orange;
    return Colors.red;
  }
}
