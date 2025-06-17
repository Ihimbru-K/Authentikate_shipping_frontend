import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'NAHPI Attendance',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16.0),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}