import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class CourseService {
  static Future<void> upload(int courseId, String filePath) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/course/upload');
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${await _getToken()}'
        ..fields['course_id'] = courseId.toString()
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        throw Exception('Upload failed: $responseBody');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}