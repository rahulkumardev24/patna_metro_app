import 'package:flutter/material.dart';
import 'package:patna_metro/utils/app_constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,

        child: Column(
          children: [
            SizedBox(height: 2.h),
            Image.asset(
              AppConstant.splashLogo,
              height: 30.w,
              fit: BoxFit.cover,
            ),

            Divider(),
          ],
        ),
      ),
    );
  }
}
