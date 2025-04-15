import 'package:clique/constants/index.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final selectedImageIndex = 0.obs;
  final cartItemCount = 0.obs;
  final isAnimating = false.obs;

  final RxList<String> productImages = <String>[].obs;

  // Make productData observable by wrapping it in an RxMap
  final RxMap<String, dynamic> productData = <String, dynamic>{}.obs;

  // void setProductData(Map<String, dynamic> data) {
//     productData.value = data; // This will trigger an update in the UI
// List<dynamic> backgroundImageList = productData['backgroundImage'];

//   productImages.assignAll(
//   backgroundImageList.map((item) => item.toString()).toList()
// );
//   }
void setProductData(Map<String, dynamic> data) {
  // if (data == null) {
  //  Get.offAllNamed(RouteName.homeScreen);
  //  return;
  // }

  // Assign data with fallback defaults
  productData.value = {
    'uid': data['uid'] ?? '',
    'backgroundImage': data['backgroundImage'] ?? [],
    'productName': data['productName'] ?? 'Unknown Product',
    'productDescription': data['productDescription'] ?? 'No description available.',
    'price': data['price'] ?? 0.0,
    'oldPrice': data['oldPrice'] ?? 0.0,
    'discount': data['discount'] ?? 0,
    'unit': data['unit'] ?? '',
    'categories': data['categories'] ?? [],
    'size': data['size'] ?? '',
  };

  List<dynamic> backgroundImageList = productData['backgroundImage'];
  productImages.assignAll(
    backgroundImageList.map((item) => item.toString()).toList(),
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
