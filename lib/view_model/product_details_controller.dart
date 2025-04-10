import 'package:get/get.dart';

class ProductController extends GetxController {
  final selectedImageIndex = 0.obs;
  final cartItemCount = 0.obs;
  final isAnimating = false.obs;

  final RxList<String> productImages = <String>[].obs;

  // Make productData observable by wrapping it in an RxMap
  final RxMap<String, dynamic> productData = <String, dynamic>{}.obs;

  void setProductData(Map<String, dynamic> data) {
    productData.value = data; // This will trigger an update in the UI

    // Set images dynamically from productData or mix with static
    productImages.assignAll([
      productData['backgroundImage'],
      productData['backgroundImage'],
      productData['backgroundImage'],
    ]);
  }

  void incrementCart() {
    isAnimating.value = true;
    cartItemCount.value++;
    Future.delayed(Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });
  }
}
