import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_color.dart';
import 'package:patna_metro/utils/app_text_style.dart';
import 'package:photo_view/photo_view.dart';

class MetroMapScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const MetroMapScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
        ),
      ),
      backgroundColor: Colors.white,
      body: PhotoView(
        imageProvider: AssetImage(imagePath),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(color: Colors.grey[100]),
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
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
                style: appTextStyle16( fontColor: Colors.grey.shade600),
              ),
              SizedBox(height: 8),
              Text(
                'Please check if the image exists at: $imagePath',
                style: appTextStyle14( fontColor: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
