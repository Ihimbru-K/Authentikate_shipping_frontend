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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error loading sessions: $e', style: const TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      );
    }
  }

  Future<void> _scanFingerprint() async {
    try {
      final result = await AttendanceService.authenticate(_sessionId!, _fingerprintController.text);
      setState(() {
        _studentDetails = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Authentication Successful', style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      );
    } catch (e) {
      setState(() {
        _studentDetails = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      );
    }
  }

  void _validateCA() {
    if (_studentDetails != null) {
      setState(() {
        _studentDetails = null;
        _fingerprintController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('CA Mark Validated', style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      );
    }
  }

  void _disputeCA() {
    if (_studentDetails != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DisputeScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.report_problem, color: Colors.white),
              const SizedBox(width: 8),
              const Text('CA Mark Dispute Initiated', style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      );
    }
  }

  Widget _buildStudentPhoto() {
    final double size = 150.w;

    if (_studentDetails?['photo'] == null) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/student_photo.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    try {
      String base64String = _studentDetails!['photo'];
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }
      final imageData = base64Decode(base64String);
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.memory(
            imageData,
            fit: BoxFit.cover,
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.person, size: 60, color: Colors.grey),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.chevron_right, color: Colors.blueAccent, size: 20),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.grey[900],
              ),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Attendance',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
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
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _fingerprintController,
                  label: 'Enter Fingerprint ID',
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Scan Fingerprint',
                  onPressed: _sessionId != null && _fingerprintController.text.isNotEmpty ? _scanFingerprint : null,
                ),
                if (_studentDetails != null) ...[
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildStudentPhoto(),
                        SizedBox(height: 20.h),
                        Text(
                          'STUDENT DETAILS',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Divider(color: Colors.grey[300], thickness: 1),
                        SizedBox(height: 12.h),
                        _buildDetailRow('Matriculation Number', _studentDetails!['matriculation_number']),
                        SizedBox(height: 12.h),
                        _buildDetailRow('Name', _studentDetails!['name']),
                        SizedBox(height: 12.h),
                        _buildDetailRow('CA Mark', _studentDetails!['ca_mark'].toString()),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _validateCA,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Validate'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 3,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _disputeCA,
                              icon: const Icon(Icons.report_problem),
                              label: const Text('Dispute'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 3,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.verified, color: Colors.green, size: 20),
                            SizedBox(width: 8.w),
                            Text(
                              'Authentication Successful',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
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
//       final adminId = prefs.getInt('admin_id') ?? 1;
//       final sessions = await DataService.fetchSessions(adminId);
//       if (mounted) setState(() => _sessions = sessions);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.white),
//               const SizedBox(width: 8),
//               Expanded(child: Text('Error loading sessions: $e', style: const TextStyle(color: Colors.white))),
//             ],
//           ),
//           backgroundColor: Colors.redAccent,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         ),
//       );
//     }
//   }
//
//   Future<void> _scanFingerprint() async {
//     try {
//       final result = await AttendanceService.authenticate(_sessionId!, _fingerprintController.text);
//       setState(() {
//         _studentDetails = result;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.white),
//               const SizedBox(width: 8),
//               const Text('Authentication Successful', style: TextStyle(color: Colors.white)),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _studentDetails = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.white),
//               const SizedBox(width: 8),
//               Expanded(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
//             ],
//           ),
//           backgroundColor: Colors.redAccent,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         ),
//       );
//     }
//   }
//
//   void _validateCA() {
//     if (_studentDetails != null) {
//       setState(() {
//         _studentDetails = null;
//         _fingerprintController.clear();
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.white),
//               const SizedBox(width: 8),
//               const Text('CA Mark Validated', style: TextStyle(color: Colors.white)),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         ),
//       );
//     }
//   }
//
//   void _disputeCA() {
//     if (_studentDetails != null) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => DisputeScreen()));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.report_problem, color: Colors.white),
//               const SizedBox(width: 8),
//               const Text('CA Mark Dispute Initiated', style: TextStyle(color: Colors.white)),
//             ],
//           ),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         ),
//       );
//     }
//   }
//
//   Widget _buildStudentPhoto() {
//     if (_studentDetails?['photo'] == null) {
//       return Container(
//         height: MediaQuery.of(context).size.height*0.25,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             'assets/student_photo.png',
//             height: 100,
//             width: 100,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               debugPrint('Asset image error: $error');
//               return Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.person, size: 50, color: Colors.grey),
//               );
//             },
//           ),
//         ),
//       );
//     }
//
//     try {
//       String base64String = _studentDetails!['photo'];
//       debugPrint('Base64 length: ${base64String.length}, starts with: ${base64String.substring(0, base64String.length > 20 ? 20 : base64String.length)}');
//       if (base64String.startsWith('data:image')) {
//         base64String = base64String.split(',').last;
//       }
//       final imageData = base64Decode(base64String);
//       return Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ClipOval(
//           child: Image.memory(
//             imageData,
//             height: 100,
//             width: 100,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               debugPrint('Image decoding error: $error');
//               return Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.person, size: 50, color: Colors.grey),
//               );
//             },
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Base64 decoding error: $e');
//       return Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             'assets/student_photo.png',
//             height: 100,
//             width: 100,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               debugPrint('Asset image error: $error');
//               return Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.person, size: 50, color: Colors.grey),
//               );
//             },
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screen_height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Exam Attendance',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.lightBlue],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue[50]!, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomDropdown<int>(
//                   label: 'Select Session',
//                   value: _sessionId,
//                   items: _sessions.map((session) => DropdownMenuItem<int>(
//                     value: session['session_id'] as int,
//                     child: Text('${session['course_code']} - ${DateFormat('yyyy-MM-dd HH:mm').format(session['start_time'])}'),
//                   )).toList(),
//                   onChanged: (value) => setState(() => _sessionId = value),
//                 ),
//                 SizedBox(height: 20.h),
//                 CustomTextField(
//                   controller: _fingerprintController,
//                   label: 'Enter Fingerprint ID',
//                   onChanged: (value) => setState(() {}),
//                 ),
//                 SizedBox(height: 20.h),
//                 CustomButton(
//                   text: 'Scan Fingerprint',
//                   onPressed: _sessionId != null && _fingerprintController.text.isNotEmpty ? _scanFingerprint : null,
//                 ),
//                 if (_studentDetails != null) ...[
//                   SizedBox(height: 20.h),
//                   Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(child: _buildStudentPhoto(),),
//                         SizedBox(height: 12.h),
//                         Text(
//                           'Student Details',
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         Text(
//                           'Matriculation Number: ${_studentDetails!['matriculation_number']}',
//                           style: TextStyle(fontSize: 16.sp, color: Colors.grey[800]),
//                         ),
//                         Text(
//                           'Name: ${_studentDetails!['name']}',
//                           style: TextStyle(fontSize: 16.sp, color: Colors.grey[800]),
//                         ),
//                         Text(
//                           'CA Mark: ${_studentDetails!['ca_mark']}',
//                           style: TextStyle(fontSize: 16.sp, color: Colors.grey[800]),
//                         ),
//
//                         SizedBox(height: 12.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _validateCA,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//                                 elevation: 2,
//                               ),
//                               child: const Text(
//                                 'Validate',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: _disputeCA,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.orange,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//                                 elevation: 2,
//                               ),
//                               child: const Text(
//                                 'Dispute CA Mark',
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8.h),
//                         Row(
//                           children: [
//                             const Icon(Icons.check_circle, color: Colors.green, size: 20),
//                             SizedBox(width: 8.w),
//                             Text(
//                               'Authentication Successful',
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
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
