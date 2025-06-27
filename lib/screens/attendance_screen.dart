import 'dart:convert';

import 'package:authentikate/screens/dispute_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/attendance_service.dart';
import '../services/data_service.dart';
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
  TextEditingController _fingerprintController = TextEditingController(text: 'fingerprint_placeholder');
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
      final adminId = prefs.getInt('admin_id') ?? 1;
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
        _fingerprintController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Validated')));
    }
  }

  void _disputeCA() {
    if (_studentDetails != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DisputeScreen()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Dispute Initiated')));
    }
  }

  // New method to handle image display
  Widget _buildStudentPhoto() {
    if (_studentDetails?['photo'] == null) {
      return Image.asset(
        'assets/student_photo.png',
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Asset image error: $error');
          return const Text('No photo available');
        },
      );
    }

    try {
      String base64String = _studentDetails!['photo'];
      // Log Base64 string for debugging
      debugPrint('Base64 length: ${base64String.length}, starts with: ${base64String.substring(0, base64String.length > 20 ? 20 : base64String.length)}');
      // Strip data URI prefix if present
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }
      final imageData = base64Decode(base64String);
      return Image.memory(
        imageData,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Image decoding error: $error');
          return Image.asset(
            'assets/student_photo.png',
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Asset image error: $error');
              return const Text('No photo available');
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Base64 decoding error: $e');
      return Image.asset(
        'assets/student_photo.png',
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Asset image error: $error');
          return const Text('No photo available');
        },
      );
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
              SizedBox(height: 16.0.h),
              CustomTextField(
                controller: _fingerprintController,
                label: 'Enter Fingerprint ID',
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 16.0.h),
              CustomButton(
                text: 'Scan Fingerprint',
                onPressed: _sessionId != null && _fingerprintController.text.isNotEmpty ? _scanFingerprint : null,
              ),
              if (_studentDetails != null) ...[
                SizedBox(height: 16.0.h),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use the new photo display method
                      _buildStudentPhoto(),
                      const SizedBox(height: 8.0),
                      Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
                      Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
                      Text('Name: ${_studentDetails!['name']}'),
                      Text('CA Mark: ${_studentDetails!['ca_mark']}'),
                      Text('Stored Fingerprint: ${_studentDetails!['fingerprint_template']}'),
                      SizedBox(height: 8.0.h),
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



















// import 'dart:convert';
//
// import 'package:authentikate/screens/dispute_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/attendance_service.dart';
// import '../services/data_service.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_textfield_widget.dart';
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
//   TextEditingController _fingerprintController = TextEditingController(text: 'fingerprint_placeholder');
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
//       final result = await AttendanceService.authenticate(_sessionId!, _fingerprintController.text);
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
//         _studentDetails = null;
//         _fingerprintController.clear();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CA Mark Validated')));
//     }
//   }
//
//   void _disputeCA() {
//     if (_studentDetails != null) {
//      // Navigator.pushNamed(context, '/dispute');
//       Navigator.push(context, MaterialPageRoute(builder: (context) => DisputeScreen()));
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
//               SizedBox(height: 16.0.h),
//               CustomTextField(
//                 controller: _fingerprintController,
//                 label: 'Enter Fingerprint ID',
//                 onChanged: (value) => setState(() {}),
//               ),
//               SizedBox(height: 16.0.h),
//               CustomButton(
//                 text: 'Scan Fingerprint',
//                 onPressed: _sessionId != null && _fingerprintController.text.isNotEmpty ? _scanFingerprint : null,
//               ),
//               if (_studentDetails != null) ...[
//                 SizedBox(height: 16.0.h),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Display photo if available
//                       _studentDetails!['photo'] != null
//                           ? Image.memory(base64Decode(_studentDetails!['photo']), height: 100)
//                           : Image.asset('assets/student_photo.png'),
//                       const SizedBox(height: 8.0),
//                       Text('Student Details', style: Theme.of(context).textTheme.titleMedium),
//                       Text('Matriculation Number: ${_studentDetails!['matriculation_number']}'),
//                       Text('Name: ${_studentDetails!['name']}'),
//                       Text('CA Mark: ${_studentDetails!['ca_mark']}'),
//                       Text('Stored Fingerprint: ${_studentDetails!['fingerprint_template']}'), // Display stored template
//                       SizedBox(height: 8.0.h),
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
//
//   @override
//   void dispose() {
//     _fingerprintController.dispose();
//     super.dispose();
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
