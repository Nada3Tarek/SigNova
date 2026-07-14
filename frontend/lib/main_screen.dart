import 'package:flutter/material.dart';
import 'package:signova/features/profile/screens/profile_screen.dart';
import 'package:signova/features/translation/screens/translation_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:signova/features/chat/screens/chat_home_screen.dart.';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final Color primaryPurple = const Color(0xFF6B4CF4);
  final Color lightPurpleBg = const Color(0xFFF2F0FF);
  final Color unselectedGrey = const Color(0xFF9E9E9E);

  final List<Widget> _pages = [
    TranslationScreen(),
    ChatHomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 3.h, top: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            title: "Translate",
            icon: Icons.people_outline,
          ),
          _buildNavItem(
            index: 1,
            title: "Chat",
            icon: Icons.chat_bubble_outline,
          ),
          _buildNavItem(index: 2, title: "Profile", icon: Icons.person_outline),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        curve: Curves.easeInOut,
        width: 24.w,
        height: 7.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? lightPurpleBg : Colors.transparent,
          borderRadius: BorderRadius.circular(25.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryPurple : unselectedGrey,
              size: 20.sp,
            ),
            SizedBox(height: 0.1.h),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? primaryPurple : unselectedGrey,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
