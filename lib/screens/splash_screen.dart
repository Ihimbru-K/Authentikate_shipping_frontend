import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/uba_logo.png', height: 150),
          const SizedBox(height: 10),
          const Text('Authentikate - UBa Attendance',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      nextScreen: const LoginScreen(),
      splashIconSize: 250,
      backgroundColor: const Color(0xFF003087),
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000, // 3 seconds
    );
  }
}