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










