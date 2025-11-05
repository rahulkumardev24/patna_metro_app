import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MetroInfoCard extends StatelessWidget {
  final Color lineColor;
  final String title;
  final String distance;
  final String fare;
  final String time;
  final String stations;
  final String interchange;

  const MetroInfoCard({
    super.key,
    required this.lineColor,
    required this.title,
    required this.distance,
    required this.fare,
    required this.time,
    required this.stations,
    required this.interchange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: appTextStyle16(
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem(distance, 'KM', Colors.red[700]!),
              _buildMetricItem(fare, 'Fare (₹)', Colors.green[600]!),
              _buildMetricItem(time, 'Min', Colors.orange[600]!),
              _buildMetricItem(stations, 'Stations', Colors.blue[600]!),
              _buildMetricItem(interchange, 'Interchange', Colors.purple[600]!),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: appTextStyle18(fontWeight: FontWeight.bold, fontColor: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: appTextStyle11(
            fontColor: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
