import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SplitPage extends StatelessWidget {
  SplitPage({
    super.key,
    required this.title,
    required this.pageIndex,
    required this.onNext,
  });
  final String title;
  final int pageIndex;
  final VoidCallback onNext;

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff6540E5), Color(0xff9F8CF2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.h,
              left: 14.w,
              right: 0.w,
              child: Image.asset(
                'assets/images/onboarding${pageIndex + 1}.png',
                height: 60.h,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 110,
              left: 28,
              right: 28,
              child: Text(
                title,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Positioned(
            //   bottom: 6.h,
            //   left: 40.w,
            //   child: Row(
            //     children: List.generate(
            //       3,
            //       (index) => DotIndicator(
            //         index: 2 - index,
            //         currentIndex: _currentPage,
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 5.h,
              right: 5.w,
              child: GestureDetector(
                onTap: onNext,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
