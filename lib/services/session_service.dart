import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class SessionService {
  static Future<void> create(int courseId, DateTime startTime, DateTime endTime) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/session/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: jsonEncode({
          'course_code': courseId.toString(), // Adjust if course_code is string
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Session creation failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Session error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}