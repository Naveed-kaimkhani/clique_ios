// view_models/product_viewmodel.dart
import 'package:clique/controller/user_controller.dart';
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

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error('');
      final fetchedProducts = await _productRepository.fetchProducts(
        page: currentPage.value,
      );
      products.assignAll(fetchedProducts);
    } catch (e) {
      error(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void loadMoreProducts() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      fetchProducts();
    }
  }
}