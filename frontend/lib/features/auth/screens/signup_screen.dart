import 'package:flutter/material.dart';
import 'package:signova/core/constants/colors.dart';
import 'package:signova/core/routing/navigation.dart';
import 'package:signova/core/routing/routes.dart';
import 'package:signova/core/shared_widget/custom_button.dart';
import 'package:signova/features/auth/widgets/custom_input_field.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.sp,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Center(
                child: Image.asset(
                  'assets/icons/black-logo.png',
                  width: 70.w,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 2.h),
              CustomInputField(
                controller: nameController,
                title: "Full Name",
                hint: "Enter your name",
                icon: Icons.person_outline,
              ),
              SizedBox(height: 2.h),
              CustomInputField(
                controller: emailController,
                title: "Email Address",
                hint: "name@example.com",
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 2.h),
              CustomInputField(
                controller: phoneController,
                title: "Phone Number",
                hint: "0101022101010",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 2.h),
              CustomInputField(
                controller: passwordController,
                title: "Password",
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    context.pushNamed(
                      Routes.optionsScreen,
                      arguments: {
                        'username': nameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'password': passwordController.text,
                      },
                    );
                  },
                  text: "Sign Up",
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.dividerColor, thickness: 2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      "OR CONTINUE WITH",
                      style: TextStyle(
                        color: AppColors.hintColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.dividerColor, thickness: 2),
                  ),
                ],
              ),

              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                height: 6.5.h,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.dividerColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.sp),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 3.w),
                      Text(
                        "Google",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signInScreen");
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
