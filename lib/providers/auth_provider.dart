import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _name;
  String? get token => _token;
  String? get name => _name;

  Future<void> login(String username, String password) async {
    try {
      final data = await AuthService.login(username, password);
      print('Login response: $data'); // Debug the full response
      _token = data['access_token'];
      _name = data['name'] ?? username; // Fallback to username if name is null
      print('Set name: $_name'); // Debug the set name
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('name', _name!); // Store name
      notifyListeners();
    } catch (e) {
      print('Login error: $e'); // Debug any errors
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signup(String username, String password, int departmentId) async {
    try {
      final data = await AuthService.signup(username, password, departmentId);
      print('Signup response: $data'); // Debug the full response
      _token = data['access_token']; // Expect token from backend
      _name = data['name'] ?? username; // Fallback to username if name not returned
      print('Set name after signup: $_name'); // Debug the set name
      if (_token == null) throw Exception('No token received');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('name', _name!);
      notifyListeners();
    } catch (e) {
      print('Signup error: $e'); // Debug any errors
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> logout() async {
    _token = null;
    _name = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    notifyListeners();
  }

  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _name = prefs.getString('name');
    notifyListeners();
  }
}










// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/auth_service.dart';
//
// class AuthProvider with ChangeNotifier {
//   String? _token;
//   String? _name;
//   String? get token => _token;
//   String? get name => _name;
//
//
//
//   Future<void> login(String username, String password) async {
//     try {
//       final data = await AuthService.login(username, password);
//       print('Login response: $data'); // Debug the full response
//       _token = data['access_token'];
//       _name = data['name']; // Should now be "admin1"
//       print('Set name: $_name'); // Debug the set name
//       if (_name == null) _name = username; // Fallback only if null
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//       await prefs.setString('name', _name!); // Store name
//       notifyListeners();
//     } catch (e) {
//       print('Login error: $e'); // Debug any errors
//       throw Exception('Login failed: $e');
//     }
//   }
//
//   // Future<void> login(String username, String password) async {
//   //   try {
//   //     final data = await AuthService.login(username, password);
//   //     _token = data['access_token'];
//   //     _name = data['name']; // Extract name from response
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.setString('token', _token!);
//   //     await prefs.setString('name', _name!); // Store name
//   //     notifyListeners();
//   //   } catch (e) {
//   //     throw Exception('Login failed: $e');
//   //   }
//   // }
//
//   Future<void> signup(String username, String password, int departmentId) async {
//     try {
//       final data = await AuthService.signup(username, password, departmentId);
//       _token = data['access_token']; // Adjust if signup returns token/name
//       _name = data['name'] ?? username; // Fallback if name not returned
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', _token!);
//       await prefs.setString('name', _name!);
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Signup failed: $e');
//     }
//   }
//
//   Future<void> logout() async {
//     _token = null;
//     _name = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('name');
//     notifyListeners();
//   }
//
//   Future<void> checkToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     _name = prefs.getString('name');
//     notifyListeners();
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
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/auth_service.dart';
// //
// // class AuthProvider with ChangeNotifier {
// //   String? _token;
// //   String? get token => _token;
// //   String? get name => _name;
// //
// //   Future<void> login(String username, String password) async {
// //     try {
// //       final data = await AuthService.login(username, password);
// //       _token = data['access_token'];
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('token', _token!);
// //       notifyListeners();
// //     } catch (e) {
// //       throw Exception('Login failed: $e');
// //     }
// //   }
// //
// //   Future<void> signup(String username, String password, int departmentId) async {
// //     try {
// //       final data = await AuthService.signup(username, password, departmentId);
// //       _token = data['access_token']; // Adjust if signup returns token
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('token', _token!);
// //       notifyListeners();
// //     } catch (e) {
// //       throw Exception('Signup failed: $e');
// //     }
// //   }
// //
// //   Future<void> logout() async {
// //     _token = null;
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('token');
// //     notifyListeners();
// //   }
// //
// //   Future<void> checkToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _token = prefs.getString('token');
// //     notifyListeners();
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // //
// // // class AuthProvider with ChangeNotifier {
// // //   String? _token;
// // //   String? get token => _token;
// // //
// // //   Future<void> login(String username, String password) async {
// // //     final url = Uri.parse('http://192.168.1.100:8000/auth/login');
// // //     final response = await http.post(
// // //       url,
// // //       headers: {'Content-Type': 'application/json'},
// // //       body: jsonEncode({'username': username, 'password': password}),
// // //     );
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       _token = data['access_token'];
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('token', _token!);
// // //       notifyListeners();
// // //     } else {
// // //       throw Exception('Login failed');
// // //     }
// // //   }
// // //
// // //   Future<void> signup(String username, String password, int departmentId) async {
// // //     final url = Uri.parse('http://localhost:8000/auth/signup');
// // //     final response = await http.post(
// // //       url,
// // //       headers: {'Content-Type': 'application/json'},
// // //       body: jsonEncode({'username': username, 'password': password, 'department_id': departmentId}),
// // //     );
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       _token = data['access_token']; // Adjust if signup returns token
// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('token', _token!);
// // //       notifyListeners();
// // //     } else {
// // //       throw Exception('Signup failed');
// // //     }
// // //   }
// // //
// // //   Future<void> logout() async {
// // //     _token = null;
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.remove('token');
// // //     notifyListeners();
// // //   }
// // //
// // //   Future<void> checkToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     _token = prefs.getString('token');
// // //     notifyListeners();
// // //   }
// // // }