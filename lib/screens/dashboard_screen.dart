import 'package:authentikate/screens/attendance_screen.dart';
import 'package:authentikate/screens/enroll_screen.dart';
import 'package:authentikate/screens/login_screen.dart';
import 'package:authentikate/screens/reports_screen.dart';
import 'package:authentikate/screens/session_screen.dart';
import 'package:authentikate/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/dashboard_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkToken(); // Ensure name is loaded
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String adminName = authProvider.name ?? 'Admin';


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        leading: const Icon(Icons.menu),
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(context, 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(
              'Welcome, $adminName!',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardCard(
                  icon: Icons.person_add,
                  title: 'Enroll Students',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EnrollScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.upload_file,
                  title: 'Upload Course List',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardCard(
                  icon: Icons.add_box,
                  title: 'Create Session',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.fingerprint,
                  title: 'Authenticate Students',
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardCard(
                  icon: Icons.description,
                  title: 'View Reports',
                  onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportsScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    authProvider.logout();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.black87, // Deep black for active
      unselectedItemColor: Colors.grey,  // Grey for inactive
      onTap: (index) {
        if (index == currentIndex) return; // Avoid duplicate nav
        switch (index) {
          case 0: Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen())); break;
          case 1: Navigator.push(context, MaterialPageRoute(builder: (context)=>EnrollScreen())); break;
          case 2: Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceScreen())); break;
          case 3: Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportsScreen())); break;
        }
      },
    );
  }

}


