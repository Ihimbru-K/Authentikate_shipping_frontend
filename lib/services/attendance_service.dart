import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AttendanceService {
  static Future<Map<String, dynamic>> authenticate(int sessionId, String fingerprintTemplate) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/attendance/authenticate');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: jsonEncode({
          'session_id': sessionId,
          'fingerprint_template': fingerprintTemplate,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Authentication failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Authentication error: $e');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}


















// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart';
//
// class AttendanceService {
//   static Future<Map<String, dynamic>> authenticate(int sessionId, String fingerprintTemplate) async {
//     try {
//       final url = Uri.parse('${Constants.apiBaseUrl}/attendance/authenticate');
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//         body: jsonEncode({
//           'session_id': sessionId,
//           'fingerprint_template': fingerprintTemplate,
//         }),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body) as Map<String, dynamic>;
//       } else {
//         throw Exception('Authentication failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Authentication error: $e');
//     }
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }