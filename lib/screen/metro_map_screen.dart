// lib/screens/metro_map_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MetroMapScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const MetroMapScreen({
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: () {
              // Zoom functionality handled by PhotoView
            },
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: () {
              // Zoom functionality handled by PhotoView
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: PhotoView(
          imageProvider: AssetImage(imagePath),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 16),
                Text(
                  'Map image not found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check if the image exists at: $imagePath',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}