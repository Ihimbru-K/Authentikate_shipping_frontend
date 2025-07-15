import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/course_service.dart';

import '../services/data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int? _courseId;
  String? _filePath;
  List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // Future<void> _loadCourses() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final deptId = (await prefs.getInt('department_id')) ?? 1; // Fetch from auth
  //     final courses = await DataService.fetchCourses(deptId);
  //     if (mounted) setState(() => _courses = courses);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading courses: $e')));
  //   }
  // }

  Future<void> _loadCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deptId = (await prefs.getInt('department_id')) ?? 1;
      print('Fetched department_id: $deptId'); // Debug print
      final courses = await DataService.fetchCourses(deptId);
      if (mounted) setState(() => _courses = courses);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading courses: $e')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Registrations'), centerTitle: true,),
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
          child: Text(course['course_code'] as String),
        )).toList(),

      //   items: _courses.map((course) => DropdownMenuItem(value: course['course_id'], child: Text(course['course_code']))).toList(),
                onChanged: (value) => setState(() => _courseId = value),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: TextEditingController(text: _filePath ?? 'Select CSV File'),
                label: 'Select CSV File',
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Choose CSV',
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
                  if (result != null) setState(() => _filePath = result.files.single.path);
                },
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Upload',
                onPressed: _courseId != null && _filePath != null
                    ? () async {
                  try {
                    await CourseService.upload(_courseId!, _filePath!);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course list uploaded!')));
                    setState(() => _filePath = null);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
                    : null,
              ),
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
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0: Navigator.pushNamed(context, '/dashboard'); break;
          case 1: Navigator.pushNamed(context, '/authenticate'); break;
          case 2: break;
          case 3: Navigator.pushNamed(context, '/settings'); break;
        }
      },
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import '../services/course_service.dart'; // To be created
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_textfield_widget.dart';
//
//
// class UploadScreen extends StatefulWidget {
//   const UploadScreen({super.key});
//
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   int? _courseId;
//   String? _filePath;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Import Registrations')),
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
//                 controller: TextEditingController(text: _filePath ?? 'Select CSV File'),
//                 label: 'Select CSV File',
//                 enabled: false,
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Choose CSV',
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
//                   if (result != null) setState(() => _filePath = result.files.single.path);
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Upload',
//                 onPressed: _courseId != null && _filePath != null
//                     ? () async {
//                   try {
//                     await CourseService.upload(_courseId!, _filePath!);
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course list uploaded!')));
//                     Navigator.pop(context);
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//                   }
//                 }
//                     : null,
//               ),
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
//         BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//       ],
//       currentIndex: 2, // Students selected
//       onTap: (index) {
//         switch (index) {
//           case 0: Navigator.pushNamed(context, '/dashboard'); break; // Home
//           case 1: Navigator.pushNamed(context, '/authenticate'); break; // Attendance
//           case 2: break; // Current screen
//           case 3: Navigator.pushNamed(context, '/settings'); break; // Settings
//         }
//       },
//     );
//   }
// }