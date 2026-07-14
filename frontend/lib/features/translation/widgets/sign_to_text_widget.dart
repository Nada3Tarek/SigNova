import 'package:flutter/material.dart';
import 'package:signova/features/translation/widgets/dark_icon_btn.dart';
import 'package:sizer/sizer.dart';

Widget buildSignToTextView({
  required String translatedText,
  required bool isLoading,
  required VoidCallback onRecordTap,
}) {
  final Color primaryPurple = const Color(0xFF6B4CF4);
  final Color lightGreyBackground = const Color(0xFFF7F8FA);

  return Column(
    key: const ValueKey("signToText"),
    children: [
      Expanded(
        flex: 6,
        child: Stack(
          children: [
            Container(width: double.infinity, color: Colors.black),
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildDarkIconButton(Icons.cameraswitch_outlined),
                    GestureDetector(
                      onTap: onRecordTap,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: lightGreyBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.videocam,
                          color: primaryPurple,
                          size: 26.sp,
                        ),
                      ),
                    ),
                    buildDarkIconButton(Icons.fullscreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 2.h),
      Expanded(
        flex: 3,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
            ],
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.more_horiz,
                      color: primaryPurple.withOpacity(0.7)),
                  SizedBox(width: 2.w),
                  Text(
                    translatedText.isEmpty
                        ? "Record a sign video"
                        : "Translation result",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                translatedText.isEmpty
                    ? "Tap the camera button to start"
                    : translatedText,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 5.h),
    ],
  );
}