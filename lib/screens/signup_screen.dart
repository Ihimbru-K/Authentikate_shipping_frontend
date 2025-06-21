import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';
import '../services/department_service.dart'; // New service to fetch departments

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int? _departmentId; // Make nullable to handle initial loading
  List<Map<String, dynamic>> _departments = []; // Store fetched departments
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    try {
      final departments = await DepartmentService.fetchDepartments();
      setState(() {
        _departments = departments;
        _departmentId = departments.isNotEmpty ? departments[0]['department_id'] : null; // Default to first if available
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching departments: $e')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/uba_logo.png', height: 100),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            DropdownButton<int>(
              value: _departmentId,
              hint: const Text('Select Department'), // Shown if _departmentId is null
              items: _departments.map((dept) {
                return DropdownMenuItem<int>(
                  value: dept['department_id'],
                  child: Text(dept['name']),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _departmentId = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _departmentId == null
                  ? null // Disable button if no department selected
                  : () async {
                if (_passwordController.text == _confirmPasswordController.text) {
                  try {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signup(_usernameController.text, _passwordController.text, _departmentId!);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Signup failed')));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                }
              },
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Login'),
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
// import '../screens/dashboard_screen.dart';
// import '../services/department_service.dart';
//
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   int? _departmentId; // Make nullable to handle initial loading
//   late Future<List<Map<String, dynamic>>> _departmentsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _departmentsFuture = DepartmentService.fetchDepartments();
//   }
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/uba_logo.png', height: 100),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration: const InputDecoration(labelText: 'Confirm Password'),
//               obscureText: true,
//             ),
//             FutureBuilder<List<Map<String, dynamic>>>(
//               future: _departmentsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No departments available');
//                 } else {
//                   final departments = snapshot.data!;
//                   return DropdownButton<int>(
//                     value: _departmentId,
//                     hint: const Text('Select Department'), // Shown when no value selected
//                     items: departments.map((dept) {
//                       return DropdownMenuItem<int>(
//                         value: dept['department_id'] as int,
//                         child: Text(dept['name'] as String),
//                       );
//                     }).toList(),
//                     onChanged: (int? newValue) {
//                       setState(() {
//                         _departmentId = newValue;
//                       });
//                     },
//                   );
//                 }
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_passwordController.text == _confirmPasswordController.text && _departmentId != null) {
//                   try {
//                     await Provider.of<AuthProvider>(context, listen: false)
//                         .signup(_usernameController.text, _passwordController.text, _departmentId!);
//                     Navigator.pushReplacement(
//                         context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
//                   } catch (e) {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(const SnackBar(content: Text('Signup failed')));
//                   }
//                 } else if (_departmentId == null) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(const SnackBar(content: Text('Please select a department')));
//                 } else {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
//                 }
//               },
//               child: const Text('Sign Up'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Back to Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

























// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../screens/dashboard_screen.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_textfield_widget.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _departmentIdController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/uba_logo.png', height: 100),
//             const SizedBox(height: 20),
//             CustomTextField(
//               controller: _usernameController,
//               label: 'Username',
//             ),
//             const SizedBox(height: 16.0), // Adjusted spacing to match UI
//             CustomTextField(
//               controller: _passwordController,
//               label: 'Password',
//               //obscureText: true, // Handled within CustomTextField if needed, but kept here for logic
//             ),
//             const SizedBox(height: 16.0), // Adjusted spacing to match UI
//             CustomTextField(
//               controller: _departmentIdController,
//               label: 'Department ID',
//               //keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             CustomButton(
//               text: 'Sign Up',
//               onPressed: () async {
//                 try {
//                   await Provider.of<AuthProvider>(context, listen: false)
//                       .signup(_usernameController.text, _passwordController.text, int.parse(_departmentIdController.text));
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (_) => DashboardScreen()));
//                 } catch (e) {
//                   print('Error: $e');
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text('Signup failed: $e')));
//                 }
//               },
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Back to Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../screens/dashboard_screen.dart';
// import 'login_screen.dart';
// import '../widgets/custom_textfield_widget.dart';
// import '../widgets/custom_button.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _departmentIdController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/uba_logo.png', height: 100),
//             const SizedBox(height: 20),
//             CustomTextField(
//               controller: _usernameController,
//               label: 'Username',
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextField(
//               controller: _passwordController,
//               label: 'Password',
//               //obscureText: true,
//             ),
//             const SizedBox(height: 16.0),
//             CustomTextField(
//               controller: _departmentIdController,
//               label: 'Department ID',
//              // keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             CustomButton(
//               text: 'Sign Up',
//               onPressed: () async {
//                 // Placeholder logic - replace with actual signup logic
//                 try {
//                   await Provider.of<AuthProvider>(context, listen: false)
//                       .signup(_usernameController.text, _passwordController.text, int.parse(_departmentIdController.text));
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (_) => DashboardScreen()));
//                 } catch (e) {
//                   print('Error: $e');
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text('Signup failed: $e')));
//                 }
//               },
//               backgroundColor: Colors.blue,
//               textColor: Colors.white,
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (_) => const LoginScreen()));
//               },
//               child: const Text('Back to Login'),
//             ),
//             const SizedBox(height: 5),
//             const Text('Need help? Contact support'),
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





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../screens/dashboard_screen.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   int _departmentId = 1; // Placeholder, fetch from API later
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Signup')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/uba_logo.png', height: 100),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration: const InputDecoration(labelText: 'Confirm Password'),
//               obscureText: true,
//             ),
//             DropdownButton<int>(
//               value: _departmentId,
//               items: [1, 2].map((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text('Department $value'),
//                 );
//               }).toList(),
//               onChanged: (int? newValue) {
//                 setState(() {
//                   _departmentId = newValue!;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_passwordController.text == _confirmPasswordController.text) {
//                   try {
//                     await Provider.of<AuthProvider>(context, listen: false)
//                         .signup(_usernameController.text, _passwordController.text, _departmentId);
//                     Navigator.pushReplacement(
//                         context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
//                   } catch (e) {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(const SnackBar(content: Text('Signup failed')));
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
//                 }
//               },
//               child: const Text('Sign Up'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Back to Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }