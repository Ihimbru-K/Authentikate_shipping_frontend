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




// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';
// import '../utils/helpers.dart'; // For file-to-base64 conversion (add if needed)
//
// class EnrollmentService {
//   static Future<void> enroll(String matriculationNumber, String name, int departmentId, int levelId, String fingerprint, String photoPath) async {
//     try {
//       print('Enrolling: matric=$matriculationNumber, name=$name, deptId=$departmentId, levelId=$levelId, fingerprint=$fingerprint, photoPath=$photoPath');
//       final photoBytes = await File(photoPath).readAsBytes();
//       final photoBase64 = base64Encode(photoBytes);
//
//       final url = Uri.parse('${Constants.apiBaseUrl}/enrollment/enroll');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//         body: jsonEncode({
//           'request': {
//             'matriculation_number': matriculationNumber,
//             'name': name,
//             'department_id': departmentId,
//             'level_id': levelId,
//             'fingerprint_template': fingerprint,
//             'photo': photoBase64,
//           },
//         }),
//       );
//       if (response.statusCode != 200) {
//         throw Exception('Enrollment failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Enrollment error: $e');
//     }
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }
//
//















//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';
// import '../utils/helpers.dart'; // For file-to-base64 conversion (add if needed)
//
// class EnrollmentService {
//   static Future<void> enroll(String matriculationNumber, String name, int departmentId, int levelId, String fingerprint, String photoPath) async {
//     try {
//       // Convert photo to base64
//       final photoBytes = await File(photoPath).readAsBytes();
//       final photoBase64 = base64Encode(photoBytes);
//
//       final url = Uri.parse('${Constants.apiBaseUrl}/enrollment/enroll');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//         body: jsonEncode({
//           'matriculation_number': matriculationNumber,
//           'name': name,
//           'department_id': departmentId,
//           'level_id': levelId,
//           'fingerprint_template': fingerprint,
//           'photo': photoBase64, // Send base64 string
//         }),
//       );
//       if (response.statusCode != 200) {
//         throw Exception('Enrollment failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Enrollment error: $e');
//     }
//   }
//
//   static Future<Map<String, dynamic>> getStatus(String fingerprint) async {
//     try {
//       final url = Uri.parse('${Constants.apiBaseUrl}/enrollment/status');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//         body: jsonEncode({'fingerprint_template': fingerprint}),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Status check failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Status error: $e');
//     }
//   }
//
//   static Future<String> downloadList(int departmentId, int levelId) async {
//     try {
//       final url = Uri.parse('${Constants.apiBaseUrl}/enrollment/list/$departmentId/$levelId');
//       final response = await http.get(
//         url,
//         headers: {'Authorization': 'Bearer ${await _getToken()}'},
//       );
//       if (response.statusCode == 200) {
//         return response.body; // Handle streaming response if needed
//       } else {
//         throw Exception('Download failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Download error: $e');
//     }
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }