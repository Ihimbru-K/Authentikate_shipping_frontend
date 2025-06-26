import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart';
import 'signup_screen.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/uba_logo.png', height: 100),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _usernameController,
              label: 'Username',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
             // obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: () async {
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .login(_usernameController.text, _passwordController.text);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => DashboardScreen()));
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Login failed: $e')));
                }
              },
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()));
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 5),
            const Text('Forgot username or password? Please try again'),
          ],
        ),
      ),
    );
  }
}




