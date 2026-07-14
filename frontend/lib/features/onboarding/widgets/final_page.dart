import 'package:flutter/material.dart';
import 'package:signova/core/shared_widget/custom_button.dart';
import 'package:sizer/sizer.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff6540E5), Color(0xff9F8CF2)],
        ),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 80.h,
            child: Image.asset(
              'assets/images/onboarding3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 22.h,
            left: 5.w,
            child: Text(
              "Bridge\nthe gap.\nconnect\ninstantly",
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 10.w,
            right: 10.w,
            child: CustomButton(
              onPressed: () => Navigator.pushNamed(context, "/signUpScreen"),
              text: "Sign Up",
            ),
          ),
        ],
      ),
    );
  }
}
