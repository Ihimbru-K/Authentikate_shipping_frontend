import 'package:authentikate/screens/attendance_screen.dart';
import 'package:authentikate/screens/enroll_screen.dart';
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
        leading: const Icon(Icons.menu),
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold),),
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
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../utils/constants.dart';
// import '../widgets/dashboard_card_widget.dart';
//
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final String adminName = authProvider.token != null ? 'Admin' : 'Admin'; // Placeholder; fetch real name later
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Icon(Icons.menu),
//         centerTitle: true,
//         title: const Text('Admin Panel', ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               authProvider.logout();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome, $adminName!',
//               style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 DashboardCard(
//                   icon: Icons.person_add,
//                   title: 'Enroll Students',
//                   onTap: () {
//                     // Navigate to Enroll Screen
//                   },
//                 ),
//                 DashboardCard(
//                   icon: Icons.upload_file,
//                   title: 'Upload Course List',
//                   onTap: () {
//                     // Navigate to Upload Screen
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 DashboardCard(
//                   icon: Icons.add_box,
//                   title: 'Create Session',
//                   onTap: () {
//                     // Navigate to Session Screen
//                   },
//                 ),
//                 DashboardCard(
//                   icon: Icons.fingerprint,
//                   title: 'Authenticate Students',
//                   onTap: () {
//                     // Navigate to Auth Screen
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 DashboardCard(
//                   icon: Icons.description,
//                   title: 'View Reports',
//                   onTap: () {
//                     // Navigate to Reports Screen
//                   },
//                 ),
//                 DashboardCard(
//                   icon: Icons.logout,
//                   title: 'Logout',
//                   onTap: () {
//                     authProvider.logout();
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
