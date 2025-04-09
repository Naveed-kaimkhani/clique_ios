import 'package:get/get.dart';
import 'package:clique/data/models/product_model.dart';

class CartQuantityController extends GetxController {
  var products = <ProductModel>[].obs;

  // Quantity for the selected product
  var quantity = 1.obs;

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void resetQuantity() {
    quantity.value = 1;
  }
}
