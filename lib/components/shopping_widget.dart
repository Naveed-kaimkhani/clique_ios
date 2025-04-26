import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/components/organic_treats_widget.dart';
import 'package:clique/components/shop_all_widget.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/profile/update_profile_screen.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingWidget extends StatelessWidget {
   final ProductViewModel _productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel());
  ShoppingWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.popstream,
    required this.onTap, // 👈 Add this line
    required this.resumeVideo,
  });

  final VoidCallback onTap; // 👈 Add this line
  final VoidCallback resumeVideo; // 👈 New

  final double screenHeight;
  final double screenWidth;
  final PopstreamModel popstream;

  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: screenHeight * 0.12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              onTap();
              Get.toNamed(RouteName.viewAllProductsScreen);
            },
            child: Container(
              height: screenHeight * 0.14,
              width: screenWidth * 0.2,
              padding: EdgeInsets.all(screenWidth * 0.02),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: ShopAllWidget(),
            ),
          ),
          GestureDetector(
            child: Container(
              height: screenHeight * 0.14,
              width: screenWidth * 0.65,
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: OrganicTreatsWidget(
                popstream: popstream,
              ),
            ),
            onTap: () async{
              onTap();
//               if (userController.phone.value.isNotEmpty) {


// ProductModel? matchingProduct = _productViewModel.products.firstWhereOrNull(
//   (product) => product.id.toString() == popstream.partyId,
// );
//   if (matchingProduct != null) {
//     Get.toNamed(RouteName.cartScreen, arguments: matchingProduct);
//   } else {
//     Get.snackbar('Not Found', 'Product not found for this party.');
//   }
// }

if (userController.phone.value.isNotEmpty) {
  ProductModel? matchingProduct = _productViewModel.products.firstWhereOrNull(
    (product) => product.id.toString() == popstream.partyId,
  );

  if (matchingProduct != null) {
    Get.toNamed(RouteName.productDetailsScreen, arguments: matchingProduct);
  } else {
    // Try to fetch from API
    final fetchedProduct = await _productViewModel.fetchProductById(
      int.tryParse(popstream.partyId) ?? -1,
    );
    if (fetchedProduct != null) {
      Get.toNamed(RouteName.productDetailsScreen, arguments: fetchedProduct);
    } else {
      Get.snackbar('Not Found', 'Product not found for this id.');
    }
  }
}

               else {
                onTap();
                Utils.showCustomSnackBar(
                    "Warning",
                    "Please enter phone number to checkout",
                    ContentType.warning);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen()));
                // resumeVideo(); //
              }
            },
          ),
        ],
      ),
    );
  }
}
