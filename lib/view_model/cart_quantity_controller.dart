import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/data/repositories/cart_storage.dart';
import 'package:clique/utils/utils.dart';
import 'package:get/get.dart';
import 'package:clique/data/models/product_model.dart';

class CartQuantityController extends GetxController {
  var products = <ProductModel>[].obs;

  // Track quantity for each product separately
  var quantities = <String, int>{}.obs; // Product ID -> Quantity
  @override
  void onInit() {
    super.onInit();
    loadCart(); // Load cart items from storage on startup
  }

  Future<void> saveCart() async {
    await CartStorage.saveCart(products);
  }

  int get totalItems => quantities.values.fold(0, (sum, item) => sum + item);

  void removeFromCart(String productId) {
    products.removeWhere((product) => product.id.toString() == productId);
    quantities.remove(productId);
    saveCart();
    Utils.showCustomSnackBar(
        "Removed", "Product removed from cart", ContentType.success);
  }

  Future<void> loadCart() async {
    List<ProductModel> loadedProducts = await CartStorage.loadCart();
    
    if (loadedProducts.isNotEmpty) {
      products.assignAll(loadedProducts);
    }
  }

  void addProduct(ProductModel product) {
    if (!products.any((p) => p.id == product.id)) {
      products.add(product);
      quantities[product.id.toString()] = 1;
      saveCart(); // Save cart after adding

      Utils.showCustomSnackBar(
          "Success", "Product Added to cart", ContentType.success);
    } else {
      Utils.showCustomSnackBar(
          "Info", "Product Already in the cart", ContentType.warning);
    }
  }

  void incrementQuantity(String productId) {
    quantities[productId] = (quantities[productId] ?? 1) + 1;
    saveCart(); // Also save quantities if needed
  }

  void decrementQuantity(String productId) {
    if ((quantities[productId] ?? 1) > 1) {
      quantities[productId] = (quantities[productId] ?? 1) - 1;
      saveCart(); // Also save quantities if needed
    }
  }

  int getQuantity(String productId) {
    return quantities[productId] ?? 1;
  }

  double getSubTotal() {
    double total = 0;
    for (var product in products) {
      total += product.cost * (quantities[product.id.toString()] ?? 1);
    }
    return total;
  }

  void clearCart() {
    products.clear();
    quantities.clear();
    CartStorage.clearCart(); // Clear from SharedPreferences too
  }
}
