import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DataService {
  static Future<List<Map<String, dynamic>>> fetchDepartments() async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/departments'); // Add this endpoint to backend
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch departments: ${response.body}');
      }
    } catch (e) {
      throw Exception('Data fetch error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLevels(int departmentId) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/levels?department_id=$departmentId'); // Add this endpoint
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch levels: ${response.body}');
      }
    } catch (e) {
      throw Exception('Data fetch error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCourses(int departmentId) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/courses?department_id=$departmentId'); // Add this endpoint
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch courses: ${response.body}');
      }
    } catch (e) {
      throw Exception('Data fetch error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}