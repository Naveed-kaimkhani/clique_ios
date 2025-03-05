import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api/api_endpoints.dart';

class ApiClient extends GetxService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    return _handleResponse(response);
  }
Future<dynamic> getGroup(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    // return _handleResponse(response);
   log(response.statusCode.toString());
   log("$response['data']");
    return response;
  }
  Future<dynamic> loginUser(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData["token"];
      final String userName = responseData["user"]["name"];
      final int userId = responseData["user"]["id"];
      // print("token: $token");
      // print("userName: $userName");
      // print("uid: $userId");
      // print(responseData["user"]["id"]);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userName', userName);
      await prefs.setInt('uid', userId);
      // loadUserSession();
      UserController().loadUserSession();
      return responseData;
    }
    return _handleResponse(response);
  }
  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }
  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) async {
  
    switch (response.statusCode) {
      case 200:
      
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 401:
      case 403:
      case 422:
      case 404:
      case 500:
        throw Exception('Error: ${response.body},');
      default:
        throw Exception('Unexpected error occurred');
    }
  }
}
