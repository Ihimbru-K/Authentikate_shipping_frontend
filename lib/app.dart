import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Match your design dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,

            title: 'NAHPI Attendance',
            theme: ThemeData(

              primarySwatch: Colors.blue,
              fontFamily: 'Roboto',
              textTheme: TextTheme(
                headlineSmall: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(fontSize: 16.sp),
              ),
            ),
            home: child,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}




