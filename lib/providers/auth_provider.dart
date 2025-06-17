import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  Future<void> login(String username, String password) async {
    final url = Uri.parse('http://localhost:8000/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> signup(String username, String password, int departmentId) async {
    final url = Uri.parse('http://localhost:8000/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'department_id': departmentId}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token']; // Adjust if signup returns token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } else {
      throw Exception('Signup failed');
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