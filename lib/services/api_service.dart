import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = Constants.apiBaseUrl;

  static Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'),
        headers: {'Authorization': 'Bearer ${await _getToken()}'});
    return response;
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${await _getToken()}'},
        body: jsonEncode(body));
    return response;
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}











// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utils/constants.dart';
//
// class ApiService {
//  // static const String baseUrl = 'http://localhost:8000';
//  // static const String baseUrl = 'http://192.168.1.100:8000'; // or your PC's local IP
//
//   static const String baseUrl = Constants.apiBaseUrl;
//
//
//   static Future<http.Response> get(String endpoint) async {
//     final response = await http.get(Uri.parse('$baseUrl$endpoint'),
//         headers: {'Authorization': 'Bearer ${await _getToken()}'});
//     return response;
//   }
//
//   static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
//     final response = await http.post(Uri.parse('$baseUrl$endpoint'),
//         headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${await _getToken()}'},
//         body: jsonEncode(body));
//     return response;
//   }
//
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
// }