import 'dart:developer';

import 'package:clique/core/api/api_client.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/data/repositories/product_repo.dart';
import 'package:get/get.dart';

class ProductViewModel extends GetxController {
  final ProductRepository _productRepository = ProductRepository();

  var products = <ProductModel>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }
// final isLoading = false.obs;

void setLoading(bool value) {
  isLoading.value = value;
}
  Future<ProductModel?> fetchProductById(int productId) async {
    try {
      final response = await _productRepository.fetchProductsById(productId);
      if (response['products'] != null &&
          response['products'] is List &&
          response['products'].isNotEmpty) {
        final product = ProductModel.fromJson(response['products'][0]);
        log("product kya hy $product");
        products.add(product); // Add to local list
        return product;
      } else {
        return null;
      }
    } catch (e) {
      log("Failed to fetch product: $e");
      return null;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error('');
      final data = await _productRepository.fetchProducts(
        page: currentPage.value,
      );

      // Extract the products and pagination details
      final List<ProductModel> fetchedProducts = (data['products'] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
      log("products length");
      log(fetchedProducts.length.toString());
      if (currentPage.value == 1) {
        products.assignAll(fetchedProducts);
      } else {
        products.addAll(fetchedProducts);
      }

      // Update pagination details
      totalPages.value = data['pagination']
          ['total_pages']; // Assuming the API provides this info
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Load more products when user reaches the end of the list
  void loadMoreProducts() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      fetchProducts();
    }
  }
}
