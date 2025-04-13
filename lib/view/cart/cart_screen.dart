import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/components/summary_row.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view/discover/appBar_backicon.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';



class CartScreen extends StatelessWidget {
  final CartQuantityController cartQuantityController =
  Get.put(CartQuantityController());
  final ProductViewModel _productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel());
final OrderViewModel orderController =
    Get.isRegistered<OrderViewModel>()
        ? Get.find<OrderViewModel>()
        : Get.put(OrderViewModel());
final AddressController controller = Get.isRegistered<AddressController>()
    ? Get.find<AddressController>()
    : Get.put(AddressController());
       
  // final AddressController controller = Get.put(AddressController());
  final String uid = Get.arguments;
  CartScreen({super.key});

  @override
Widget build(BuildContext context) {
  

  return SafeArea(
    bottom: false,
    child: Scaffold(
      appBar: AppBarWithBackIcon(
        title: "My Cart",
        // icon: Icons.arrow_back_ios,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        // Wait until products are loaded
        if (_productViewModel.products.isEmpty) {
          return const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            Text("Fetching Product Details...")
            ],
          ));
        }
  
        final product = _productViewModel.products.firstWhereOrNull((e) => e.id.toString() == uid);
  
        if (product != null &&
            !cartQuantityController.products.any((p) => p.id == product.id)) {
          cartQuantityController.products.add(product);
        }
  
        return Column(
          children: [
            Expanded(
              child: product == null
                  ? const Center(child: Text("Product not found!"))
                  : ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                         
  Hero(
    tag: uid,
    child: ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: CachedNetworkImage(
    imageUrl: product.imageUrls.first,
    width: 84,
    height: 84,
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 84,
        height: 84,
        color: Colors.white,
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  ),
    ),
  ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        GradientText(
                                          "\$${product.cost.toStringAsFixed(2)}",
                                          gradient: AppColors.appGradientColors,
                                          fontSize: 16.36,
                                        ),
                                      ],
                                    ),
                                //  IconButton(
                                //               icon: const Icon(Icons.edit),
                                //               onPressed: () =>controller.clearAddress() ,
                                //             ),
                                    Obx(() => Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline),
                                              onPressed: () => cartQuantityController.decrementQuantity(),
                                            ),
                                            Text(
                                              "${cartQuantityController.quantity.value}",
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline),
                                              onPressed: () => cartQuantityController.incrementQuantity(),
                                            ),
                                            const Spacer(),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              height: 230,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Divider(thickness: 1),
                  Obx(() => SummaryRow(
                        title: "Sub Total",
                        amount: (product?.cost ?? 0.0) * cartQuantityController.quantity.value,
                        isBold: true,
                      )),
                  const SizedBox(height: 60),
                
  
                  AuthButton(
                    buttonText:"Checkout" , 
                    onPressed:   () {

                      log(controller.address1.value);
                      
                      log(controller.address2.value);
                      
                      log(controller.city.value);
                      
                      log(controller.countryCode.value);
                      
                      log(controller.stateCode.value);
                      log(controller.zipCode.value);
                      
                      if (controller.address1.value.isEmpty) {
                      Get.toNamed(RouteName.checkoutScreen);
                        return;
                      }else{
                      
                          // Get.toNamed(RouteName.checkoutScreen);
                      orderController.submitOrderFromCart().then( (value) {
                        if (value != null) {
                          Get.toNamed(RouteName.checkoutScreen);
                        } else {
                          Get.snackbar("Error", "Failed to submit order");
                        }
                      });
                      }
                    },
                    isLoading: orderController.isLoading)
                ],
              ),
            ),
          ],
        );
      }),
    ),
  );
}

}
