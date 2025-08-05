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










