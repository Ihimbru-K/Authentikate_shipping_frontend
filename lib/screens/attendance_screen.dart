import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/attendance_service.dart';
import '../services/data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int? _sessionId;
  TextEditingController _fingerprintController = TextEditingController(text: 'fingerprint_placeholder'); // Manual input
  List<Map<String, dynamic>> _sessions = [];
  Map<String, dynamic>? _studentDetails;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminId = (await prefs.getInt('admin_id')) ?? 1;
      final sessions = await DataService.fetchSessions(adminId);
      if (mounted) setState(() => _sessions = sessions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
    }
  }

  Future<void> _scanFingerprint() async {
    try {
      final result = await AttendanceService.authenticate(_sessionId!, _fingerprintController.text);
      setState(() {
        _studentDetails = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication Successful')));
    } catch (e) {
      setState(() {
        _studentDetails = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _validateCA() {
    if (_studentDetails != null) {
      setState(() {
        _studentDetails = null;
        _fingerprintController.clear(); // Clear for next student
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Validated')));
    }
  }

  void _disputeCA() {
    if (_studentDetails != null) {
      Navigator.pushNamed(context, '/dispute'); // Placeholder route
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Dispute Initiated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown<int>(
                label: 'Select Session',
                value: _sessionId,
                items: _sessions.map((session) => DropdownMenuItem<int>(
                  value: session['session_id'] as int,
                  child: Text('${session['course_code']} - ${DateFormat('yyyy-MM-dd HH:mm').format(session['start_time'])}'),
                )).toList(),
                onChanged: (value) => setState(() => _sessionId = value),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _fingerprintController,
                label: 'Enter Fingerprint ID',
                onChanged: (value) => setState(() {}), // Update state on input
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Scan Fingerprint',
                onPressed: _sessionId != null && _fingerprintController.text.isNotEmpty ? _scanFingerprint : null,
              ),
              if (_studentDetails != null) ...[
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display photo if available
                      _studentDetails!['photo'] != null
                          ? Image.memory(base64Decode(_studentDetails!['photo']), height: 100)
                          : Image.asset('assets/student_photo.png'),
                      const SizedBox(height: 8.0),
                      Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
                      Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
                      Text('Name: ${_studentDetails!['name']}'),
                      Text('CA Mark: ${_studentDetails!['ca_mark']}'),
                      Text('Stored Fingerprint: ${_studentDetails!['fingerprint_template']}'), // Display stored template
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _validateCA,
                            child: const Text('Validate'),
                          ),
                          ElevatedButton(
                            onPressed: _disputeCA,
                            child: const Text('Dispute CA Mark'),
                          ),
                        ],
                      ),
                      const Text('Authentication Successful', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fingerprintController.dispose();
    super.dispose();
  }
}











// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/attendance_service.dart';
// import '../services/data_service.dart';
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_dropdown_widget.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//
//   @override
//   _AttendanceScreenState createState() => _AttendanceScreenState();
// }
//
// class _AttendanceScreenState extends State<AttendanceScreen> {
//   int? _sessionId;
//   String? _fingerprintTemplate = 'fingerprint_placeholder'; // Using enrollment placeholder for now
//   List<Map<String, dynamic>> _sessions = [];
//   Map<String, dynamic>? _studentDetails;
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
//       final sessions = await DataService.fetchSessions(adminId);
//       if (mounted) setState(() => _sessions = sessions);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
//     }
//   }
//
//   Future<void> _scanFingerprint() async {
//     try {
//       final result = await AttendanceService.authenticate(_sessionId!, _fingerprintTemplate!);
//       setState(() {
//         _studentDetails = result;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication Successful')));
//     } catch (e) {
//       setState(() {
//         _studentDetails = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
//
//   void _validateCA() {
//     if (_studentDetails != null) {
//       setState(() {
//         _studentDetails = null; // Clear for next student
//       });
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Validated')));
//     }
//   }
//
//   void _disputeCA() {
//     if (_studentDetails != null) {
//       // Navigate to dispute screen (to be implemented)
//       Navigator.pushNamed(context, '/dispute'); // Placeholder route
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Dispute Initiated')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Exam Attendance')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomDropdown<int>(
//                 label: 'Select Session',
//                 value: _sessionId,
//                 items: _sessions.map((session) => DropdownMenuItem<int>(
//                   value: session['session_id'] as int,
//                   child: Text('${session['course_code']} - ${DateFormat('yyyy-MM-dd HH:mm').format(session['start_time'])}'),
//                 )).toList(),
//                 onChanged: (value) => setState(() => _sessionId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Scan Fingerprint',
//                 onPressed: _sessionId != null ? _scanFingerprint : null,
//               ),
//               if (_studentDetails != null) ...[
//                 const SizedBox(height: 16.0),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset('assets/student_photo.png'), // Replace with actual photo logic
//                       const SizedBox(height: 8.0),
//                       Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
//                       Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
//                       Text('Name: ${_studentDetails!['name']}'),
//                       Text('CA Mark: ${_studentDetails!['ca_mark']}'),
//                       const SizedBox(height: 8.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: _validateCA,
//                             child: const Text('Validate'),
//                           ),
//                           ElevatedButton(
//                             onPressed: _disputeCA,
//                             child: const Text('Dispute CA Mark'),
//                           ),
//                         ],
//                       ),
//                       const Text('Authentication Successful', style: TextStyle(color: Colors.green)),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
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
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/attendance_service.dart';
// // import '../services/data_service.dart';
// // import '../utils/constants.dart';
// // import '../widgets/custom_button.dart';
// // import '../widgets/custom_dropdown_widget.dart';
// //
// // class AttendanceScreen extends StatefulWidget {
// //   const AttendanceScreen({super.key});
// //
// //   @override
// //   _AttendanceScreenState createState() => _AttendanceScreenState();
// // }
// //
// // class _AttendanceScreenState extends State<AttendanceScreen> {
// //   int? _sessionId;
// //   String? _fingerprintTemplate = 'fingerprint_placeholder'; // Replace with scanner input
// //   List<Map<String, dynamic>> _sessions = [];
// //   Map<String, dynamic>? _studentDetails;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSessions();
// //   }
// //
// //   Future<void> _loadSessions() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final adminId = (await prefs.getInt('admin_id')) ?? 1; // Fetch from auth
// //       final sessions = await DataService.fetchSessions(adminId);
// //       if (mounted) setState(() => _sessions = sessions);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
// //     }
// //   }
// //
// //   Future<void> _scanFingerprint() async {
// //     try {
// //       final result = await AttendanceService.authenticate(_sessionId!, _fingerprintTemplate!);
// //       setState(() {
// //         _studentDetails = result;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication Successful')));
// //     } catch (e) {
// //       setState(() {
// //         _studentDetails = null;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Exam Attendance')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               CustomDropdown<int>(
// //                 label: 'Select Session',
// //                 value: _sessionId,
// //                 items: _sessions.map((session) => DropdownMenuItem<int>(
// //                   value: session['session_id'] as int,
// //                   child: Text('${session['course_code']} - ${DateFormat('yyyy-MM-dd HH:mm').format(session['start_time'])}'),
// //                 )).toList(),
// //                 onChanged: (value) => setState(() => _sessionId = value),
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomButton(
// //                 text: 'Scan Fingerprint',
// //                 onPressed: _sessionId != null ? _scanFingerprint : null,
// //               ),
// //               if (_studentDetails != null) ...[
// //                 const SizedBox(height: 16.0),
// //                 Container(
// //                   padding: const EdgeInsets.all(16.0),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[200],
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Image.asset('assets/student_photo.png'), // Replace with actual photo logic
// //                       const SizedBox(height: 8.0),
// //                       Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
// //                       Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
// //                       Text('Name: ${_studentDetails!['name']}'),
// //                       Text('CA Mark: ${_studentDetails!['ca_mark']}'),
// //                       const SizedBox(height: 8.0),
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           // Dispute CA Mark logic
// //                         },
// //                         child: const Text('Dispute CA Mark'),
// //                       ),
// //                       const Text('Authentication Successful', style: TextStyle(color: Colors.green)),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../services/attendance_service.dart';
// // // import '../services/data_service.dart'; // For session data
// // // import '../utils/constants.dart';
// // // import '../widgets/custom_button.dart';
// // // import '../widgets/custom_dropdown_widget.dart';
// // //
// // // class AttendanceScreen extends StatefulWidget {
// // //   const AttendanceScreen({super.key});
// // //
// // //   @override
// // //   _AttendanceScreenState createState() => _AttendanceScreenState();
// // // }
// // //
// // // class _AttendanceScreenState extends State<AttendanceScreen> {
// // //   int? _sessionId;
// // //   String? _fingerprintTemplate = 'fingerprint_placeholder'; // Replace with actual scanner input
// // //   List<Map<String, dynamic>> _sessions = [];
// // //   Map<String, dynamic>? _studentDetails;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadSessions();
// // //   }
// // //
// // //   Future<void> _loadSessions() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final adminId = (await prefs.getInt('admin_id')) ?? 1; // Fetch from auth
// // //       final sessions = await DataService.fetchSessions(adminId); // Implement this
// // //       if (mounted) setState(() => _sessions = sessions);
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading sessions: $e')));
// // //     }
// // //   }
// // //
// // //   Future<void> _scanFingerprint() async {
// // //     try {
// // //       final result = await AttendanceService.authenticate(_sessionId!, _fingerprintTemplate!);
// // //       setState(() {
// // //         _studentDetails = result;
// // //       });
// // //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication Successful')));
// // //     } catch (e) {
// // //       setState(() {
// // //         _studentDetails = null;
// // //       });
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Exam Attendance')),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               CustomDropdown<int>(
// // //                 label: 'Select Session',
// // //                 value: _sessionId,
// // //                 items: _sessions.map((session) => DropdownMenuItem<int>(
// // //                   value: session['session_id'] as int,
// // //                   child: Text('${session['course_code']} - ${DateFormat('yyyy-MM-dd HH:mm').format(session['start_time'])}'),
// // //                 )).toList(),
// // //                 onChanged: (value) => setState(() => _sessionId = value),
// // //               ),
// // //               const SizedBox(height: 16.0),
// // //               CustomButton(
// // //                 text: 'Scan Fingerprint',
// // //                 onPressed: _sessionId != null ? _scanFingerprint : null,
// // //               ),
// // //               if (_studentDetails != null) ...[
// // //                 const SizedBox(height: 16.0),
// // //                 Container(
// // //                   padding: const EdgeInsets.all(16.0),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.grey[200],
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Image.asset('assets/student_photo.png'), // Replace with actual photo logic
// // //                       const SizedBox(height: 8.0),
// // //                       Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
// // //                       Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
// // //                       Text('Name: ${_studentDetails!['name']}'),
// // //                       Text('CA Mark: ${_studentDetails!['ca_mark']}'),
// // //                       const SizedBox(height: 8.0),
// // //                       ElevatedButton(
// // //                         onPressed: () {
// // //                           // Dispute CA Mark logic
// // //                         },
// // //                         child: const Text('Dispute CA Mark'),
// // //                       ),
// // //                       const Text('Authentication Successful', style: TextStyle(color: Colors.green)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }