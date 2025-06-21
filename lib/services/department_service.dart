import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DepartmentService {
  static Future<List<Map<String, dynamic>>> fetchDepartments() async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/departments');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}', // Assuming admin is logged in or token is stored
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch departments: ${response.body}');
      }
    } catch (e) {
      throw Exception('Department fetch error: $e');
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
// class DepartmentService {
//   static Future<List<Map<String, dynamic>>> fetchDepartments() async {
//     try {
//       final url = Uri.parse('${Constants.apiBaseUrl}/departments');
//       final response = await http.get(
//         url,
//         headers: {'Authorization': 'Bearer ${await _getToken()}'},
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as List;
//         return data.map((dept) => {
//           'department_id': dept['department_id'] as int,
//           'name': dept['name'] as String,
//         }).toList();
//       } else {
//         throw Exception('Failed to fetch departments: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching departments: $e');
//     }
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }