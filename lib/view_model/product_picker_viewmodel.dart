// ------------------ ViewModel ------------------
import 'dart:async';
import 'dart:convert';

import 'package:clique/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:http/http.dart' as http;
class ProductPickerViewModel extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<ProductModel> selectedProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  Timer? _debounce;

  void onSearchChanged(String value, String token) {
    searchQuery.value = value;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (value.isNotEmpty) {
        fetchProducts(value, token);
      } else {
        searchResults.clear();
      }
    });
  }

  Future<void> fetchProducts(String query, String token) async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(
            'https://cactisocial.com/api-clique/public/api/v1/topdawg/products?search=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> productList = data['products'];
        searchResults.value =
            productList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        searchResults.clear();
      }
    } catch (_) {
      searchResults.clear();
    } finally {
      isLoading(false);
    }
  }

  void toggleProductSelection(ProductModel product) {
    final exists = selectedProducts.any((p) => p.id == product.id);
    if (exists) {
      selectedProducts.removeWhere((p) => p.id == product.id);
      Fluttertoast.showToast(
        msg: "${product.productTitle} removed from selection.",
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      );
    } else {
      selectedProducts.add(product);
      Fluttertoast.showToast(
        msg: "${product.productTitle} added to selection.",
        backgroundColor: Colors.green.withOpacity(0.8),
      );
    }
  }
}
