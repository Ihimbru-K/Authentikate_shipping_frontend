import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class CourseService {
  static Future<void> upload(int courseId, String filePath) async {
    try {
      print('DEBUG: Starting upload - courseId=$courseId, filePath=$filePath');

      // Construct URL with course_id as query parameter
      final url = Uri.parse('${Constants.apiBaseUrl}/course/upload?course_id=$courseId');
      print('DEBUG: URL: $url');

      // Prepare multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${await _getToken()}'
        ..files.add(await http.MultipartFile.fromPath('file', filePath, contentType: MediaType('text', 'csv'))); // Specify CSV content type

      print('DEBUG: Request fields: ${request.fields}, files: ${request.files.map((f) => f.filename)}');

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('DEBUG: Response status: ${response.statusCode}, body: $responseBody');

      if (response.statusCode != 200) {
        throw Exception('Upload failed: $responseBody');
      }
    } catch (e) {
      print('DEBUG: Exception caught: $e');
      throw Exception('Upload error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('DEBUG: Token: $token');
    return token;
  }
}























// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';
//
// class CourseService {
//   static Future<void> upload(int courseId, String filePath) async {
//     try {
//       final url = Uri.parse('${Constants.apiBaseUrl}/course/upload');
//       final request = http.MultipartRequest('POST', url)
//         ..headers['Authorization'] = 'Bearer ${await _getToken()}'
//         ..fields['course_id'] = courseId.toString()
//         ..files.add(await http.MultipartFile.fromPath('file', filePath));
//
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//       if (response.statusCode != 200) {
//         throw Exception('Upload failed: $responseBody');
//       }
//     } catch (e) {
//       throw Exception('Upload error: $e');
//     }
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }