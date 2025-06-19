



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../services/enrollment_service.dart';
import '../services/data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_textfield_widget.dart';

class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key});

  @override
  _EnrollScreenState createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  final _matricController = TextEditingController(text: 'e.g., 20A1001');
  final _nameController = TextEditingController(text: 'e.g., John Doe');
  final _fingerprintController = TextEditingController(text: 'fingerprint_placeholder');
  int? _departmentId;
  int? _levelId;
  String? _photoPath;
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _levels = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _matricController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _fingerprintController.addListener(() => setState(() {}));
  }

  Future<void> _loadDepartments() async {
    try {
      final depts = await DataService.fetchDepartments();
      if (mounted) {
        setState(() => _departments = depts);
        if (_departments.isNotEmpty) _loadLevels(_departments.first['department_id']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading departments: $e')));
    }
  }

  Future<void> _loadLevels(int deptId) async {
    try {
      final lvls = await DataService.fetchLevels(deptId);
      if (mounted) setState(() => _levels = lvls);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading levels: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(controller: _matricController, label: 'Matriculation Number', hint: 'e.g., 20A1001'),
              const SizedBox(height: 16.0),
              CustomTextField(controller: _nameController, label: 'Name', hint: 'e.g., John Doe'),
              const SizedBox(height: 16.0),
              CustomDropdown<int>(
                label: 'Department',
                value: _departmentId,
                items: _departments.map((dept) => DropdownMenuItem<int>(
                  value: dept['department_id'] as int,
                  child: Text(dept['name']),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _departmentId = value;
                    _levelId = null;
                    _levels = [];
                    if (value != null) _loadLevels(value);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              CustomDropdown<int>(
                label: 'Level',
                value: _levelId,
                items: _levels.map((lvl) => DropdownMenuItem<int>(
                  value: lvl['level_id'] as int,
                  child: Text(lvl['name']),
                )).toList(),
                onChanged: (value) => setState(() => _levelId = value),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(controller: _fingerprintController, label: 'Fingerprint Template', hint: 'fingerprint_placeholder'),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: TextEditingController(text: _photoPath ?? 'Select Photo'),
                label: 'Upload Photo',
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Choose Photo',
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) setState(() => _photoPath = result.files.single.path);
                },
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Enroll',
                onPressed: _departmentId != null && _levelId != null && _photoPath != null
                    ? () async {
                  try {
                    await EnrollmentService.enroll(
                      _matricController.text,
                      _nameController.text,
                      _departmentId!,
                      _levelId!,
                      _fingerprintController.text,
                      _photoPath!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student enrolled!')));
                    _matricController.clear();
                    _nameController.clear();
                    _fingerprintController.text = 'fingerprint_placeholder';
                    setState(() => _photoPath = null);
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





















// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';
// import '../services/data_service.dart';
// import '../services/enrollment_service.dart';
//
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_textfield_widget.dart';
//
// class EnrollScreen extends StatefulWidget {
//   const EnrollScreen({super.key});
//
//   @override
//   _EnrollScreenState createState() => _EnrollScreenState();
// }
//
// class _EnrollScreenState extends State<EnrollScreen> {
//   final _matricController = TextEditingController(text: 'e.g., 20A1001');
//   final _nameController = TextEditingController(text: 'e.g., John Doe');
//   final _fingerprintController = TextEditingController(text: 'fingerprint_placeholder');
//   int? _departmentId;
//   int? _levelId;
//   String? _photoPath;
//   List<Map<String, dynamic>> _departments = [];
//   List<Map<String, dynamic>> _levels = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDepartments();
//     _matricController.addListener(() => setState(() {}));
//     _nameController.addListener(() => setState(() {}));
//     _fingerprintController.addListener(() => setState(() {}));
//   }
//
//   Future<void> _loadDepartments() async {
//     try {
//       final depts = await DataService.fetchDepartments();
//       if (mounted) {
//         setState(() => _departments = depts);
//         if (_departments.isNotEmpty) _loadLevels(_departments.first['department_id']);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading departments: $e')));
//     }
//   }
//
//   Future<void> _loadLevels(int deptId) async {
//     try {
//       final lvls = await DataService.fetchLevels(deptId);
//       if (mounted) setState(() => _levels = lvls);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading levels: $e')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register Student')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextField(controller: _matricController, label: 'Matriculation Number', hint: 'e.g., 20A1001'),
//               const SizedBox(height: 16.0),
//               CustomTextField(controller: _nameController, label: 'Name', hint: 'e.g., John Doe'),
//               const SizedBox(height: 16.0),
//               CustomDropdown<int>(
//                 label: 'Department',
//                 value: _departmentId,
//                 items: _departments.map((dept) => DropdownMenuItem(value: dept['department_id'], child: Text(dept['name']))).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _departmentId = value;
//                     _levelId = null;
//                     _levels = [];
//                     if (value != null) _loadLevels(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomDropdown<int>(
//                 label: 'Level',
//                 value: _levelId,
//                 items: _levels.map((lvl) => DropdownMenuItem(value: lvl['level_id'], child: Text(lvl['name']))).toList(),
//                 onChanged: (value) => setState(() => _levelId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomTextField(controller: _fingerprintController, label: 'Fingerprint Template', hint: 'fingerprint_placeholder'),
//               const SizedBox(height: 16.0),
//               CustomTextField(
//                 controller: TextEditingController(text: _photoPath ?? 'Select Photo'),
//                 label: 'Upload Photo',
//                 enabled: false,
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Choose Photo',
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(type: FileType.image);
//                   if (result != null) setState(() => _photoPath = result.files.single.path);
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Enroll',
//                 onPressed: _departmentId != null && _levelId != null && _photoPath != null
//                     ? () async {
//                   try {
//                     await EnrollmentService.enroll(
//                       _matricController.text,
//                       _nameController.text,
//                       _departmentId!,
//                       _levelId!,
//                       _fingerprintController.text,
//                       _photoPath!,
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student enrolled!')));
//                     _matricController.clear();
//                     _nameController.clear();
//                     _fingerprintController.text = 'fingerprint_placeholder';
//                     setState(() => _photoPath = null);
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






















































// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';
// import '../providers/student_provider.dart'; // To be created if needed
// import '../services/enrollment_service.dart';
// import '../utils/constants.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_dropdown_widget.dart';
// import '../widgets/custom_textfield_widget.dart';
//
// class EnrollScreen extends StatefulWidget {
//   const EnrollScreen({super.key});
//
//   @override
//   _EnrollScreenState createState() => _EnrollScreenState();
// }
//
// class _EnrollScreenState extends State<EnrollScreen> {
//   final _matricController = TextEditingController(text: 'e.g., 20A1234');
//   final _nameController = TextEditingController(text: 'e.g., Alice Njaya');
//   int? _departmentId;
//   int? _levelId;
//   String _fingerprint = ''; // Placeholder for SecuGen SDK
//   String? _photoPath;
//
//   @override
//   void initState() {
//     super.initState();
//     _matricController.addListener(() => setState(() {}));
//     _nameController.addListener(() => setState(() {}));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register Student')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextField(
//                 controller: _matricController,
//                 label: 'Matriculation Number',
//                 hint: 'e.g., 20A1234',
//               ),
//               const SizedBox(height: 16.0),
//               CustomTextField(
//                 controller: _nameController,
//                 label: 'Name',
//                 hint: 'e.g., Alice Njaya',
//               ),
//               const SizedBox(height: 16.0),
//               CustomDropdown<int>(
//                 label: 'Department',
//                 value: _departmentId,
//                 items: [1, 2].map((id) => DropdownMenuItem(value: id, child: Text('Dept $id'))).toList(),
//                 onChanged: (value) => setState(() => _departmentId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomDropdown<int>(
//                 label: 'Level',
//                 value: _levelId,
//                 items: [200, 300].map((id) => DropdownMenuItem(value: id, child: Text('Level $id'))).toList(),
//                 onChanged: (value) => setState(() => _levelId = value),
//               ),
//               const SizedBox(height: 16.0),
//               CustomTextField(
//                 controller: TextEditingController(text: _fingerprint),
//                 label: 'Scan Fingerprint',
//                 enabled: false,
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Scan Fingerprint',
//                 onPressed: () {
//                   // Integrate SecuGen SDK here
//                   setState(() => _fingerprint = 'placeholder'); // Mock
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Upload Photo',
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(type: FileType.image);
//                   if (result != null) setState(() => _photoPath = result.files.single.path);
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 text: 'Enroll',
//                 onPressed: _departmentId != null && _levelId != null && _fingerprint.isNotEmpty && _photoPath != null
//                     ? () async {
//                   try {
//                     await EnrollmentService.enroll(
//                       _matricController.text,
//                       _nameController.text,
//                       _departmentId!,
//                       _levelId!,
//                       _fingerprint,
//                       _photoPath!,
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student enrolled!')));
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
//         BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
//         BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
//       ],
//       currentIndex: 1, // Register selected
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
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/student_provider.dart'; // To be created
// // import '../services/enrollment_service.dart'; // To be created
// // import '../utils/constants.dart';
// // import '../widgets/custom_button.dart';
// // import '../widgets/custom_dropdown_widget.dart';
// // import '../widgets/custom_textfield_widget.dart';
// //
// // class EnrollScreen extends StatefulWidget {
// //   const EnrollScreen({super.key});
// //
// //   @override
// //   _EnrollScreenState createState() => _EnrollScreenState();
// // }
// //
// // class _EnrollScreenState extends State<EnrollScreen> {
// //   final _matricController = TextEditingController(text: 'e.g., 20A1234');
// //   final _nameController = TextEditingController(text: 'e.g., Alice Njaya');
// //   int? _departmentId;
// //   int? _levelId;
// //   String _fingerprint = ''; // Placeholder for SecuGen SDK
// //   String? _photoPath; // For photo upload
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _matricController.addListener(() => setState(() {}));
// //     _nameController.addListener(() => setState(() {}));
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Register Student')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               CustomTextField(
// //                 controller: _matricController,
// //                 label: 'Matriculation Number',
// //                 hint: 'e.g., 20A1234',
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomTextField(
// //                 controller: _nameController,
// //                 label: 'Name',
// //                 hint: 'e.g., Alice Njaya',
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomDropdown<int>(
// //                 label: 'Department',
// //                 value: _departmentId,
// //                 items: [1, 2].map((id) => DropdownMenuItem(value: id, child: Text('Dept $id'))).toList(),
// //                 onChanged: (value) => setState(() => _departmentId = value),
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomDropdown<int>(
// //                 label: 'Level',
// //                 value: _levelId,
// //                 items: [200, 300].map((id) => DropdownMenuItem(value: id, child: Text('Level $id'))).toList(),
// //                 onChanged: (value) => setState(() => _levelId = value),
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomTextField(
// //                 controller: TextEditingController(text: _fingerprint),
// //                 label: 'Scan Fingerprint',
// //                 enabled: false,
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomButton(
// //                 text: 'Scan Fingerprint',
// //                 onPressed: () {
// //                   // Integrate SecuGen SDK here
// //                   setState(() => _fingerprint = 'placeholder'); // Mock
// //                 },
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomButton(
// //                 text: 'Upload Photo',
// //                 onPressed: () async {
// //                   // File picker for photo
// //                   final result = await pickFile();
// //                   if (result != null) setState(() => _photoPath = result.files.single.path);
// //                 },
// //               ),
// //               const SizedBox(height: 16.0),
// //               CustomButton(
// //                 text: 'Enroll',
// //                 onPressed: _departmentId != null && _levelId != null && _fingerprint.isNotEmpty && _photoPath != null
// //                     ? () async {
// //                   try {
// //                     await EnrollmentService.enroll(_matricController.text, _nameController.text, _departmentId!, _levelId!, _fingerprint, _photoPath!);
// //                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student enrolled!')));
// //                     Navigator.pop(context);
// //                   } catch (e) {
// //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
// //                   }
// //                 }
// //                     : null,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       bottomNavigationBar: _buildBottomNavBar(context),
// //     );
// //   }
// //
// //   Future<FilePickerResult?> pickFile() async {
// //     return await FilePicker.platform.pickFiles(type: FileType.image);
// //   }
// //
// //   Widget _buildBottomNavBar(BuildContext context) {
// //     return BottomNavigationBar(
// //       items: const [
// //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //         BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
// //         BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
// //         BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Reports'),
// //       ],
// //       currentIndex: 1, // Register selected
// //       onTap: (index) {
// //         switch (index) {
// //           case 0: Navigator.pushNamed(context, '/dashboard'); break; // Home
// //           case 1: break; // Current screen
// //           case 2: Navigator.pushNamed(context, '/authenticate'); break; // Attendance
// //           case 3: Navigator.pushNamed(context, '/reports'); break; // Reports
// //         }
// //       },
// //     );
// //   }
// // }