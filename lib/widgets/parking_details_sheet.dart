import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ParkingDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> place;
  final Position? currentPosition;
  final Function(double, double) onGetDirections;

  const ParkingDetailsSheet({
    super.key,
    required this.place,
    required this.currentPosition,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    final rating = place['rating']?.toDouble() ?? 0.0;
    final isOpen = place['opening_hours']?['open_now'] ?? false;
    final userRatingsTotal = place['user_ratings_total'] ?? 0;
    final parkingType = place['type'] ?? 'Public Parking';
    final capacity = place['capacity'] ?? 'Not specified';
    final fee = place['fee'] ?? 'Not specified';

    double? distance;
    if (currentPosition != null) {
      final double startLat = currentPosition!.latitude;
      final double startLng = currentPosition!.longitude;
      final double endLat = place['geometry']['location']['lat'];
      final double endLng = place['geometry']['location']['lng'];

      distance = _calculateDistanceBetween(startLat, startLng, endLat, endLng);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_parking,
                  color: Colors.blue[700],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown Parking',
                      style: appTextStyle18(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isOpen ? 'Currently Open' : 'Currently Closed',
                        style: appTextStyle12(
                          fontColor: isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Parking Details Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailChip(Icons.category, parkingType),
                _buildDetailChip(Icons.people, capacity),
                _buildDetailChip(Icons.attach_money, fee),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Address
          _buildDetailItem(
            icon: Icons.location_on,
            title: 'Address',
            color: Colors.red,
            subtitle: place['vicinity'] ?? 'No address available',
          ),
          const SizedBox(height: 16),

          // Distance
          if (distance != null)
            Column(
              children: [
                _buildDetailItem(
                  icon: Icons.place,
                  color: Colors.blue,
                  title: 'Distance from you',
                  subtitle: '${distance.toStringAsFixed(1)} kilometers',
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Rating
          if (rating > 0)
            Column(
              children: [
                _buildDetailItem(
                  icon: Icons.star,
                  title: 'Rating',
                  color: Colors.orange,
                  subtitle: '$rating ($userRatingsTotal reviews)',
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Actions
          SizedBox(
            width: 100.w,
            child: OutlinedButton.icon(
              onPressed: () {
                onGetDirections(
                  place['geometry']['location']['lat'],
                  place['geometry']['location']['lng'],
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.directions, size: 21, color: Colors.white),
              label: Text(
                'Get Directions',
                style: appTextStyle16(fontColor: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: appTextStyle12(
                  fontColor: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: appTextStyle15(fontColor: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(height: 4),
        Text(
          text,
          style: appTextStyle12(
            fontColor: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  double _calculateDistanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const double earthRadius = 6371;

    double dLat = _toRadians(endLat - startLat);
    double dLng = _toRadians(endLng - startLng);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}
