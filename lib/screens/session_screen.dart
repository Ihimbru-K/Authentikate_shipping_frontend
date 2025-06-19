import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/session_service.dart';
import '../services/data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  int? _courseId;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
  List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deptId = (await prefs.getInt('department_id')) ?? 1; // Fetch from auth
      final courses = await DataService.fetchCourses(deptId);
      if (mounted) setState(() => _courses = courses);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading courses: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Exam')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown<int>(
                label: 'Select Course',
                value: _courseId,
                items: _courses.map((course) => DropdownMenuItem<int>(
                  value: course['course_id'] as int,
                  child: Text(course['course_code']),
                )).toList(),
                onChanged: (value) => setState(() => _courseId = value),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_startTime)),
                label: 'Select Date',
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: _startTime, firstDate: DateTime(2025), lastDate: DateTime(2026));
                  if (date != null) setState(() => _startTime = date);
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(text: DateFormat('HH:mm').format(_startTime)),
                      label: 'Start Time',
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_startTime));
                        if (time != null) setState(() => _startTime = DateTime(_startTime.year, _startTime.month, _startTime.day, time.hour, time.minute));
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(text: DateFormat('HH:mm').format(_endTime)),
                      label: 'End Time',
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_endTime));
                        if (time != null) setState(() => _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day, time.hour, time.minute));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Create',
                onPressed: _courseId != null
                    ? () async {
                  try {
                    await SessionService.create(_courseId!, _startTime, _endTime);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam session created successfully!')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
                    : null,
              ),
              const SizedBox(height: 8.0),
              Text('Exam sessions overlap. Please adjust times.', style: TextStyle(color: Constants.errorColor, fontSize: 12.0)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
      ],
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0: Navigator.pushNamed(context, '/dashboard'); break;
          case 1: break;
          case 2: Navigator.pushNamed(context, '/authenticate'); break;
          case 3: Navigator.pushNamed(context, '/reports'); break;
        }
      },
    );
  }
}






















// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/session_service.dart';
//
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_textfield_widget.dart';
//
// class SessionScreen extends StatefulWidget {
//   const SessionScreen({super.key});
//
//   @override
//   _SessionScreenState createState() => _SessionScreenState();
// }
//
// class _SessionScreenState extends State<SessionScreen> {
//   int? _courseId;
//   DateTime _startTime = DateTime.now();
//   DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
//   List<Map<String, dynamic>> _courses = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCourses();
//   }
//
//   Future<void> _loadCourses() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final deptId = (await prefs.getInt('department_id')) ?? 1; // Fetch from auth
//       final courses = await DataService.fetchCourses(deptId);
//       if (mounted) setState(() => _courses = courses);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading courses: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Schedule Exam')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomDropdown<int>(
//                 label: 'Select Course',
//                 value: _courseId,
//                 items: _courses.map((course) => DropdownMenuItem(value: course['course_id'], child: Text(course['course_code']))).toList(),
//                 onChanged: (value) => setState(() => _courseId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomTextField(
//                 controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_startTime)),
//                 label: 'Select Date',
//                 onTap: () async {
//                   final date = await showDatePicker(context: context, initialDate: _startTime, firstDate: DateTime(2025), lastDate: DateTime(2026));
//                   if (date != null) setState(() => _startTime = date);
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomTextField(
//                       controller: TextEditingController(text: DateFormat('HH:mm').format(_startTime)),
//                       label: 'Start Time',
//                       onTap: () async {
//                         final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_startTime));
//                         if (time != null) setState(() => _startTime = DateTime(_startTime.year, _startTime.month, _startTime.day, time.hour, time.minute));
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Expanded(
//                     child: CustomTextField(
//                       controller: TextEditingController(text: DateFormat('HH:mm').format(_endTime)),
//                       label: 'End Time',
//                       onTap: () async {
//                         final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_endTime));
//                         if (time != null) setState(() => _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day, time.hour, time.minute));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Create',
//                 onPressed: _courseId != null
//                     ? () async {
//                   try {
//                     await SessionService.create(_courseId!, _startTime, _endTime);
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam session created successfully!')));
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//                   }
//                 }
//                     : null,
//               ),
//               const SizedBox(height: 8.0),
//               Text('Exam sessions overlap. Please adjust times.', style: TextStyle(color: Constants.errorColor, fontSize: 12.0)),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavBar(context),
//     );
//   }
//
//   Widget _buildBottomNavBar(BuildContext context) {
//     return BottomNavigationBar(
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
//         BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
//       ],
//       currentIndex: 1,
//       onTap: (index) {
//         switch (index) {
//           case 0: Navigator.pushNamed(context, '/dashboard'); break;
//           case 1: break;
//           case 2: Navigator.pushNamed(context, '/authenticate'); break;
//           case 3: Navigator.pushNamed(context, '/reports'); break;
//         }
//       },
//     );
//   }
// }
//
















// import 'package:flutter/material.dart';
//
// import '../services/session_service.dart'; // To be created
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
//
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_textfield_widget.dart';
// import 'package:intl/intl.dart';
//
//
// class SessionScreen extends StatefulWidget {
//   const SessionScreen({super.key});
//
//   @override
//   _SessionScreenState createState() => _SessionScreenState();
// }
//
// class _SessionScreenState extends State<SessionScreen> {
//   int? _courseId;
//   DateTime _startTime = DateTime.now();
//   DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Schedule Exam')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomDropdown<int>(
//                 label: 'Select Course',
//                 value: _courseId,
//                 items: [1, 2].map((id) => DropdownMenuItem(value: id, child: Text('Course $id'))).toList(),
//                 onChanged: (value) => setState(() => _courseId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomTextField(
//                 controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_startTime)),
//                 label: 'Select Date',
//                 onTap: () async {
//                   final date = await showDatePicker(context: context, initialDate: _startTime, firstDate: DateTime(2025), lastDate: DateTime(2026));
//                   if (date != null) setState(() => _startTime = date);
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomTextField(
//                       controller: TextEditingController(text: DateFormat('HH:mm').format(_startTime)),
//                       label: 'Start Time',
//                       onTap: () async {
//                         final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_startTime));
//                         if (time != null) setState(() => _startTime = DateTime(_startTime.year, _startTime.month, _startTime.day, time.hour, time.minute));
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Expanded(
//                     child: CustomTextField(
//                       controller: TextEditingController(text: DateFormat('HH:mm').format(_endTime)),
//                       label: 'End Time',
//                       onTap: () async {
//                         final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_endTime));
//                         if (time != null) setState(() => _endTime = DateTime(_endTime.year, _endTime.month, _endTime.day, time.hour, time.minute));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Create',
//                 onPressed: _courseId != null
//                     ? () async {
//                   try {
//                     await SessionService.create(_courseId!, _startTime, _endTime);
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam session created successfully!')));
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//                   }
//                 }
//                     : null,
//               ),
//               const SizedBox(height: 8.0),
//               Text('Exam sessions overlap. Please adjust times.', style: TextStyle(color: Constants.errorColor, fontSize: 12.0)),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavBar(context),
//     );
//   }
//
//   Widget _buildBottomNavBar(BuildContext context) {
//     return BottomNavigationBar(
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
//         BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
//       ],
//       currentIndex: 1, // Register selected
//       onTap: (index) {
//         switch (index) {
//           case 0: Navigator.pushNamed(context, '/dashboard'); break; // Home
//           case 1: break; // Current screen
//           case 2: Navigator.pushNamed(context, '/authenticate'); break; // Attendance
//           case 3: Navigator.pushNamed(context, '/reports'); break; // Reports
//         }
//       },
//     );
//   }
// }