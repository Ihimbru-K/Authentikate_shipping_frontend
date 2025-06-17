import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await ApiService.post('/auth/login', {'username': username, 'password': password});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> signup(String username, String password, int departmentId) async {
    final response = await ApiService.post('/auth/signup', {
      'username': username,
      'password': password,
      'department_id': departmentId
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Signup failed: ${response.body}');
    }
  }
}