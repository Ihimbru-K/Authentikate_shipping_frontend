import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';
import '../services/department_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int? _departmentId;
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;

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
        _departmentId =
        departments.isNotEmpty ? departments[0]['department_id'] : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching departments: $e')));
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Signup',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ),
        backgroundColor: Colors.teal[700],
        elevation: 4,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400.w),
              child: _isLoading
                  ? const Center(
                  child: CircularProgressIndicator(color: Colors.teal))
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/uba_logo.png',
                    height: 150.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(
                      _usernameController, 'Username', Icons.person),
                  SizedBox(height: 16.h),
                  _buildTextField(_passwordController, 'Password',
                      Icons.lock,
                      obscureText: true),
                  SizedBox(height: 16.h),
                  _buildTextField(_confirmPasswordController,
                      'Confirm Password', Icons.lock,
                      obscureText: true),
                  SizedBox(height: 16.h),

                  /// ✅ FIXED: Responsive Dropdown
                  DropdownButtonFormField<int>(
                    value: _departmentId,
                    isExpanded: true, // <-- important!
                    hint: const Text(
                      'Select Department',
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: _departments.map((dept) {
                      return DropdownMenuItem<int>(
                        value: dept['department_id'],
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            dept['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _departmentId = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: _departmentId == null
                        ? null
                        : () async {
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        try {
                          await Provider.of<AuthProvider>(context,
                              listen: false)
                              .signup(
                              _usernameController.text,
                              _passwordController.text,
                              _departmentId!);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  const DashboardScreen()));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content:
                              Text('Signup failed')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Passwords do not match')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Colors.teal[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontSize: 16.sp, color: Colors.white)),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                          fontSize: 14.sp, color: Colors.teal[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      style: TextStyle(fontSize: 14.sp),
    );
  }
}






