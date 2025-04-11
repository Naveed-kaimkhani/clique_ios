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
List<dynamic> backgroundImageList = productData['backgroundImage'];

  productImages.assignAll(
  backgroundImageList.map((item) => item.toString()).toList()
);
  }

  void incrementCart() {
    isAnimating.value = true;
    cartItemCount.value++;
    Future.delayed(Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });
  }
}
