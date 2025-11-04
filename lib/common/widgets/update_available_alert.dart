import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_notifier/config/app_images.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateAvailableAlert extends StatelessWidget {
  const 
  UpdateAvailableAlert({super.key, required this.storeLink});

  final String storeLink;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Platform.isIOS
                ? Image.asset(AppImages.appStore, height: 24)
                : Image.asset(AppImages.playStore, height: 24),
            SizedBox(width: 12.sp),
            Text(
              'Update Available',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'New version of DSM is now available on ${Platform.isIOS ? 'App Store' : 'Play Store'}. Please update it',
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    launchUrlString(storeLink);
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
