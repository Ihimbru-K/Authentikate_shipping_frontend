import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class EnrollmentService {
  static Future<void> enroll(String matriculationNumber, String name, int departmentId, int levelId, String fingerprint, String photoPath) async {
    try {
      print('DEBUG: Starting enrollment - Inputs: matric=$matriculationNumber, name=$name, deptId=$departmentId, levelId=$levelId, fingerprint=$fingerprint, photoPath=$photoPath');

      // Prepare multipart request
      var request = http.MultipartRequest('POST', Uri.parse('${Constants.apiBaseUrl}/enrollment/enroll'));
      request.headers['Authorization'] = 'Bearer ${await _getToken()}';

      // Add form fields
      request.fields['matriculation_number'] = matriculationNumber;
      request.fields['name'] = name;
      request.fields['department_id'] = departmentId.toString();
      request.fields['level_id'] = levelId.toString();
      request.fields['fingerprint_template'] = fingerprint;

      // Add photo file
      if (photoPath != null) {
        var photoFile = await http.MultipartFile.fromPath(
          'photo',
          photoPath,
          contentType: MediaType('image', 'jpg'), // Adjust based on file type
        );
        request.files.add(photoFile);
      }

      print('DEBUG: Request fields: ${request.fields}, files: ${request.files.map((f) => f.filename)}');

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('DEBUG: Response status: ${response.statusCode}, body: $responseBody');

      if (response.statusCode != 200) {
        throw Exception('Enrollment failed: $responseBody');
      }
    } catch (e) {
      print('DEBUG: Exception caught: $e');
      throw Exception('Enrollment error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('DEBUG: Token: $token');
    return token;
  }
}


