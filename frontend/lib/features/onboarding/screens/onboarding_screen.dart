import 'package:flutter/material.dart';
import 'package:signova/core/constants/colors.dart';
import 'package:signova/features/onboarding/widgets/final_page.dart';
import 'package:signova/features/onboarding/widgets/split_page.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                SplitPage(
                  title:
                      "Watch text\ntransform into sign\nlanguage during\nyour chat",
                  pageIndex: 0,
                  onNext: () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                SplitPage(
                  title:
                      "See your text turn\ninto signs during\nyour conversation.",
                  pageIndex: 1,
                  onNext: () {
                    if (_currentPage < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                FinalPage(),
              ],
            ),

            Positioned(
              top: 3.h,
              left: 3.w,
              child: TextButton(
                onPressed: () {
                  _pageController.jumpToPage(2);
                },
                child: Text(
                  "skip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
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
