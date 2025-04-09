import 'dart:developer';

import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/custom_button.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/components/summary_row.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CartScreen extends StatelessWidget {
  
  final ProductViewModel _productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel());

   CartQuantityController _cartQuantityController=   Get.put(CartQuantityController());
  final String uid = Get.arguments;
  CartScreen({super.key});

  @override
  @override
Widget build(BuildContext context) {
  log("CartScreen build called");
  log(uid);

  return Container(
    decoration: BoxDecoration(
      gradient: AppColors.appGradientColors,
    ),
    child: SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "My Cart",
          icon: Icons.arrow_back_ios,
        ),
        backgroundColor: Colors.white,
        body: Obx(() {
          // Wait until products are loaded
          if (_productViewModel.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = _productViewModel.products.firstWhereOrNull((e) => e.id.toString() == uid);

          if (product != null &&
              !_cartQuantityController.products.any((p) => p.id == product.id)) {
            _cartQuantityController.products.add(product);
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
                                    child: Image.network(
                                      product.imageUrls.first,
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
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
                                      Obx(() => Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline),
                                                onPressed: () => _cartQuantityController.decrementQuantity(),
                                              ),
                                              Text(
                                                "${_cartQuantityController.quantity.value}",
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline),
                                                onPressed: () => _cartQuantityController.incrementQuantity(),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: AppColors.appColor),
                                                onPressed: () {
                                                  _cartQuantityController.products.removeWhere((e) => e.id.toString() == uid);
                                                },
                                              ),
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
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Divider(thickness: 1),
                    Obx(() => SummaryRow(
                          title: "Total",
                          amount: (product?.cost ?? 0.0) * _cartQuantityController.quantity.value,
                          isBold: true,
                        )),
                    const SizedBox(height: 60),
                    CustomButton(
                      onTap: () {
                        Get.toNamed(RouteName.checkoutScreen);
                      },
                      text: "Checkout",
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    ),
  );
}

}
