import 'dart:math';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api_endpoints.dart';

class ApiClient extends GetxService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint), headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'), headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
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
