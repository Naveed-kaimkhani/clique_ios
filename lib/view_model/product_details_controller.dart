import 'package:get/get.dart';

class ProductController extends GetxController {
  final selectedImageIndex = 0.obs;
  final cartItemCount = 0.obs;
  final isAnimating = false.obs;

  final RxList<String> productImages = <String>[].obs;

  late Map<String, dynamic> productData;

  void setProductData(Map<String, dynamic> data) {
    productData = data;

    // Set images dynamically from productData or mix with static
    productImages.assignAll([
      // 'https://example.com/image1.jpg',
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
