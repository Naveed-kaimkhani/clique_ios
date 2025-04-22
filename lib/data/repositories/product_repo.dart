import 'dart:convert';
import 'dart:developer';
import 'package:clique/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String baseUrl = 'https://cactisocial.com/api-clique/public/api/v1/topdawg/products';

  final userController = Get.find<UserController>();

  Future<Map<String, dynamic>> fetchProducts({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await http.get(
      Uri.parse('https://cactisocial.com/api-clique/public/api/v1/topdawg/products?page=$page'),
      headers: {
        'Authorization': 'Bearer ${userController.token.value}',
        'Accept': 'application/json',
      },
    
    );
log(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data; // Return the full response to include pagination info
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
