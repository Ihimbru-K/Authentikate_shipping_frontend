import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DisputeService {
  static Future<void> submitDispute(int sessionId, String matriculationNumber, int courseId, String details) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/attendance/dispute');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: jsonEncode({
          'session_id': sessionId,
          'matriculation_number': matriculationNumber,
          'course_id': courseId,
          'details': details,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Dispute submission failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Dispute error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}