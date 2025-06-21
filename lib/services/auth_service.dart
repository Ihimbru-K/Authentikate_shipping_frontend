import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  // static Future<Map<String, dynamic>> login(String username, String password) async {
  //   final response = await ApiService.post('/auth/login', {'username': username, 'password': password});
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Login failed: ${response.body}');
  //   }
  // }
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/auth/login');
    print('Login request to: $url with $username, $password'); // Debug the request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // No auth header needed
      body: jsonEncode({'username': username, 'password': password}),
    );
    print('Login response status: ${response.statusCode}, body: ${response.body}'); // Debug response
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




















// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../utils/constants.dart';
// import 'api_service.dart';
//
// class AuthService {
//
//   final endpt = "http://192.168.1.100:8000/auth/login";
//   static Future<Map<String, dynamic>> login(String username, String password) async {
//     final response = await ApiService.post('/auth/login', {'username': username, 'password': password});
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Login failed: ${response.body}');
//     }
//   }
//
//   Future<http.Response> logi(username, password) async{
//     return http.post(Uri.parse(endpt), );
//
//   }
//
//   static Future<Map<String, dynamic>> signup(String username, String password, int departmentId) async {
//     final response = await ApiService.post('/auth/signup', {
//       'username': username,
//       'password': password,
//       'department_id': departmentId
//     });
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Signup failed: ${response.body}');
//     }
//   }
// }