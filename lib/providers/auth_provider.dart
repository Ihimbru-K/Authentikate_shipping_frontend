import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  Future<void> login(String username, String password) async {
    try {
      final data = await AuthService.login(username, password);
      _token = data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signup(String username, String password, int departmentId) async {
    try {
      final data = await AuthService.signup(username, password, departmentId);
      _token = data['access_token']; // Adjust if signup returns token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}








// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthProvider with ChangeNotifier {
//   String? _token;
//   String? get token => _token;
//
//   Future<void> login(String username, String password) async {
//     final url = Uri.parse('http://192.168.1.100:8000/auth/login');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'password': password}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       _token = data['access_token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//       notifyListeners();
//     } else {
//       throw Exception('Login failed');
//     }
//   }
//
//   Future<void> signup(String username, String password, int departmentId) async {
//     final url = Uri.parse('http://localhost:8000/auth/signup');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'password': password, 'department_id': departmentId}),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       _token = data['access_token']; // Adjust if signup returns token
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//       notifyListeners();
//     } else {
//       throw Exception('Signup failed');
//     }
//   }
//
//   Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     notifyListeners();
//   }
//
//   Future<void> checkToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     notifyListeners();
//   }
// }