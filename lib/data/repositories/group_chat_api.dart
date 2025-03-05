import 'dart:convert';
import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupChatRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  late SharedPreferences _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Map<String, String>? _getAuthHeaders() {
    final token = _prefs.getString('token');
    log("token");
    log(token.toString());
    if (token == null) return null;

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", 
    };
  }

  String? _getUserId() {
    return _prefs.getString('uid');
  }

  Future<List<Map<String, dynamic>>?> fetchMessages(String guid) async {
    try {
      await _initPrefs();
      final headers = _getAuthHeaders();
      final userId = _getUserId();
      log(headers.toString());
      log(userId.toString());
      if (headers == null || userId == null) {
        throw Exception('Authentication failed - missing token or user ID');
      }

      final url = Uri.parse("${_apiClient.baseUrl}/cometchat/groups/$guid/messages");
      final response = await http.get(url, headers: headers);
      log("response body");
      log(response.body);
      if (response.statusCode != 200) {
        log(response.body);
        throw Exception('Failed to load messages: ${response.statusCode} - ${response.body}');
      }

      final List<dynamic> responseData = jsonDecode(response.body);
      log(responseData.toString());
      return _parseMessages(responseData, userId);

    } catch (e) {
      Utils.showCustomSnackBar("Error",e.toString(),ContentType.failure);
      // print('Error in fetchMessages: $e');
      log('Error in fetchMessages: $e');
      return null;
    }
  }

  List<Map<String, dynamic>> _parseMessages(List<dynamic> messages, String userId) {
    return messages.map<Map<String, dynamic>>((msg) => {
      "sender": msg["name"] ?? "Unknown",
      "message": msg["message"] ?? "",
      // "isMe": msg["sender_uid"] == userId,
      "time": "Now",
      "seenBy": [],
    }).toList();
  }

  Future<bool> sendMessage(String guid, String message) async {
    if (message.isEmpty) return false;

    try {
      await _initPrefs();
      final headers = _getAuthHeaders();
      final userId = _getUserId();

      if (headers == null || userId == null) {
        throw Exception('Authentication failed - missing token or user ID');
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.sendMessage),
        headers: headers,
        body: jsonEncode({
          "group_id": guid,
          "sender_uid": userId,
          "message": message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message: ${response.body}');
      }

      return true;

    } catch (e) {
      print('Error in sendMessage: $e');
      return false;
    }
  }
}
