import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../services/report_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_button.dart';
import 'attendance_screen.dart';
import 'dashboard_screen.dart';
import 'enroll_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int? _sessionId;
  List<Map<String, dynamic>> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminId = (await prefs.getInt('admin_id')) ?? 1;
      final sessions = await ReportService.fetchSessions(adminId);
      if (mounted) setState(() => _sessions = sessions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
    }
  }

  Future<void> _downloadAttendance() async {
    if (_sessionId != null) {
      final file = await ReportService.downloadAttendance(_sessionId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded: ${file.path}')));
      _showShareDialog(file);
    }
  }

  Future<void> _downloadErrors() async {
    if (_sessionId != null) {
      final file = await ReportService.downloadErrors(_sessionId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded: ${file.path}')));
      _showShareDialog(file);
    }
  }

  Future<void> _showShareDialog(File file) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Report'),
        content: const Text('Would you like to share this file via WhatsApp or another app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ReportService.shareFile(file);
              Navigator.pop(context);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports', ), centerTitle: true,),
      bottomNavigationBar: buildBottomNavBar(context, 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown<int>(
              label: 'Select Session ID',
              value: _sessionId,
              items: _sessions.map((session) => DropdownMenuItem<int>(
                value: session['session_id'] as int,
                child: Text('${session['session_id']} - ${session['course_code']}'),
              )).toList(),
              onChanged: (value) => setState(() => _sessionId = value),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Download Attendance',
              onPressed: _sessionId != null ? _downloadAttendance : null,
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Download Errors',
              onPressed: _sessionId != null ? _downloadErrors : null,
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


















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import '../services/report_service.dart';
// import '../utils/constants.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_button.dart';
//
// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});
//
//   @override
//   _ReportsScreenState createState() => _ReportsScreenState();
// }
//
// class _ReportsScreenState extends State<ReportsScreen> {
//   int? _sessionId;
//   List<Map<String, dynamic>> _sessions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSessions();
//   }
//
//   Future<void> _loadSessions() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final adminId = (await prefs.getInt('admin_id')) ?? 1;
//       final sessions = await ReportService.fetchSessions(adminId);
//       if (mounted) setState(() => _sessions = sessions);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
//     }
//   }
//
//   Future<void> _downloadAttendance() async {
//     if (_sessionId != null) {
//       final file = await ReportService.downloadAttendance(_sessionId!);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to: ${file.path}')));
//     }
//   }
//
//   Future<void> _downloadErrors() async {
//     if (_sessionId != null) {
//       final file = await ReportService.downloadErrors(_sessionId!);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to: ${file.path}')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Reports')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomDropdown<int>(
//               label: 'Select Session ID',
//               value: _sessionId,
//               items: _sessions.map((session) => DropdownMenuItem<int>(
//                 value: session['session_id'] as int,
//                 child: Text('${session['session_id']} - ${session['course_code']}'),
//               )).toList(),
//               onChanged: (value) => setState(() => _sessionId = value),
//             ),
//             const SizedBox(height: 16.0),
//             CustomButton(
//               text: 'Download Attendance',
//               onPressed: _sessionId != null ? _downloadAttendance : null,
//             ),
//             const SizedBox(height: 16.0),
//             CustomButton(
//               text: 'Download Errors',
//               onPressed: _sessionId != null ? _downloadErrors : null,
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





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import '../services/report_service.dart';
// import '../utils/constants.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_button.dart';
//
// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});
//
//   @override
//   _ReportsScreenState createState() => _ReportsScreenState();
// }
//
// class _ReportsScreenState extends State<ReportsScreen> {
//   int? _sessionId;
//   List<Map<String, dynamic>> _sessions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSessions();
//   }
//
//   Future<void> _loadSessions() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final adminId = (await prefs.getInt('admin_id')) ?? 1;
//       final sessions = await ReportService.fetchSessions(adminId);
//       if (mounted) setState(() => _sessions = sessions);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
//     }
//   }
//
//   Future<void> _downloadAttendance() async {
//     if (_sessionId != null) {
//       final file = await ReportService.downloadAttendance(_sessionId!);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to: ${file.path}')));
//     }
//   }
//
//   Future<void> _downloadErrors() async {
//     if (_sessionId != null) {
//       final file = await ReportService.downloadErrors(_sessionId!);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to: ${file.path}')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Reports')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomDropdown<int>(
//               label: 'Select Session ID',
//               value: _sessionId,
//               items: _sessions.map((session) => DropdownMenuItem<int>(
//                 value: session['session_id'] as int,
//                 child: Text('${session['session_id']} - ${session['course_code']}'),
//               )).toList(),
//               onChanged: (value) => setState(() => _sessionId = value),
//             ),
//             const SizedBox(height: 16.0),
//             CustomButton(
//               text: 'Download Attendance',
//               onPressed: _sessionId != null ? _downloadAttendance : null,
//             ),
//             const SizedBox(height: 16.0),
//             CustomButton(
//               text: 'Download Errors',
//               onPressed: _sessionId != null ? _downloadErrors : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }