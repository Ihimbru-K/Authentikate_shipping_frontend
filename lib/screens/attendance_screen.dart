import 'dart:convert';

import 'package:authentikate/screens/dispute_screen.dart';
import 'package:authentikate/screens/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/attendance_service.dart';
import '../services/data_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_textfield_widget.dart';
import 'dashboard_screen.dart';
import 'enroll_screen.dart';

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
      ),
      bottomNavigationBar: buildBottomNavBar(context, 2),
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
  Widget buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.blueGrey),
      onTap: (index) {
        if (index == currentIndex) return;
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
































