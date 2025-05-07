import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/auth_button.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/components/summary_row.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view/discover/appBar_backicon.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartQuantityController = Get.find<CartQuantityController>();

  final OrderViewModel orderController = Get.isRegistered<OrderViewModel>()
      ? Get.find<OrderViewModel>()
      : Get.put(OrderViewModel(), permanent: true);

  final AddressController controller = Get.isRegistered<AddressController>()
      ? Get.find<AddressController>()
      : Get.put(AddressController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBarWithBackIcon(title: "My Cart"),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: cartQuantityController.products.length,
                  itemBuilder: (context, index) {
                    final product = cartQuantityController.products[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: product.id.toString(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrls.first,
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                      width: 84,
                                      height: 84,
                                      color: Colors.white),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                GradientText(
                                  "\$${product.cost.toStringAsFixed(2)}",
                                  gradient: AppColors.appGradientColors,
                                  fontSize: 16.36,
                                ),
                                Obx(() => Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: () =>
                                              cartQuantityController
                                                  .decrementQuantity(
                                                      product.id.toString()),
                                        ),
                                        Text(
                                          "${cartQuantityController.getQuantity(product.id.toString())}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: () =>
                                              cartQuantityController
                                                  .incrementQuantity(
                                                      product.id.toString()),
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
                  }),
            ),
            Container(
              height: 230,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Divider(thickness: 1),
                  // Obx(() => SummaryRow(
                  //       title: "Sub Total",
                  //       amount: (product.cost) *
                  //           cartQuantityController.quantity.value,
                  //       isBold: true,
                  //     )),
                  Obx(() => SummaryRow(
                        title: "Sub Total",
                        amount: cartQuantityController.getSubTotal(),
                        isBold: true,
                      )),

                  const SizedBox(height: 60),
                  AuthButton(
                    buttonText: "Checkout",
                    onPressed: () {
                  
                      if (controller.address1.value.isEmpty) {
                        Get.toNamed(RouteName.checkoutScreen);
                        return;
                      } else {
                        orderController.submitOrderFromCart().then((value) {
                          if (value != null) {
                            Get.toNamed(RouteName.checkoutScreen);
                          }
                        });
                      }
                    },
                    isLoading: orderController.isLoading,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
