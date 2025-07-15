import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Adjust to match your base design (e.g. iPhone 12)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnimatedSplashScreen(
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bigger logo, fully responsive
              SizedBox(
                width: 250.r,
                height: 250.r,
                child: Image.asset(
                  'assets/images/uba_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                'Authentikate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "UBa Exam Attendance System",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          nextScreen: const LoginScreen(),
          splashIconSize: 400.r, // Match the larger logo
          backgroundColor: const Color(0xFF003087),
          splashTransition: SplashTransition.fadeTransition,
          duration: 7000,
        );
      },
    );
  }
}
