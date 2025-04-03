// repositories/product_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  final String baseUrl = 'https://moutfits.com/product.json';

  Future<List<ProductModel>> fetchProducts({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await http.get(
      // Uri.parse('$baseUrl?page=$page&per_page=$perPage'),
      
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}