
import 'dart:convert';
import 'dart:developer';
import 'package:clique/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  final String baseUrl = 'https://dev.moutfits.com/api/v1/topdawg/products?page=1&per_page=10';

  final userController = Get.find<UserController>();
Future<List<ProductModel>> fetchProducts({
  int page = 1,
  int perPage = 10,
}) async {
  final String token = 'YOUR_BEARER_TOKEN_HERE'; // Replace with your actual token

  final response = await http.get(
    Uri.parse('$baseUrl?page=$page&per_page=$perPage'),
    headers: {
      'Authorization': 'Bearer ${userController.token.value}',
      'Accept': 'application/json',
    },
  );

  log(response.body.toString());

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> productsJson = data['products'];
    return productsJson.map((json) => ProductModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products: ${response.statusCode}');
  }
}

}