import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ReportService {
  static Future<List<Map<String, dynamic>>> fetchSessions(int adminId) async {
    try {
      final url = Uri.parse('${Constants.apiBaseUrl}/sessions?admin_id=$adminId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((session) => {
          'session_id': session['session_id'] as int,
          'course_code': session['course_code'] as String,
        }).toList();
      } else {
        throw Exception('Failed to fetch sessions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching sessions: $e');
    }
  }

  static Future<File> downloadAttendance(int sessionId) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/reports/attendance/$sessionId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${await _getToken()}'},
    );
    if (response.statusCode == 200) {
      final directory = await _getDownloadDirectory();
      final file = File('${directory.path}/attendance_report_$sessionId.csv');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download attendance report: ${response.statusCode}');
    }
  }

  static Future<File> downloadErrors(int sessionId) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/reports/errors/$sessionId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${await _getToken()}'},
    );
    if (response.statusCode == 200) {
      final directory = await _getDownloadDirectory();
      final file = File('${directory.path}/error_report_$sessionId.csv');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download error report: ${response.statusCode}');
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    // For Android, use external storage (Downloads)
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory;
    }
    // For iOS, use Documents directory (user-accessible via Files app)
    return await getApplicationDocumentsDirectory();
  }

  static Future<void> shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'Check out this report!');
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}