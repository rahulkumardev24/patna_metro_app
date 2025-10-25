import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patna_metro/screen/home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.w),

              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(100),
                child: Image.asset(
                  'lib/assets/images/logo.png',
                  height: 50.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 2.h),

              Spacer(),

              // Tagline
              const Text(
                'Smart Travel • Fast • Safe',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
