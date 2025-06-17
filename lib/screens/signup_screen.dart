import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int _departmentId = 1; // Placeholder, fetch from API later

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/nahpi_uba_logo.png', height: 100),
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
              items: [1, 2].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Department $value'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _departmentId = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_passwordController.text == _confirmPasswordController.text) {
                  try {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signup(_usernameController.text, _passwordController.text, _departmentId);
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