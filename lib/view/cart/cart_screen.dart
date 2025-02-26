import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/custom_button.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/controller/cart_controller.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  final String uid = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "My Cart", icon: Icons.arrow_back_ios,),
          backgroundColor: Colors.white,
        
          body: Column(
            
            children: [
              Expanded(
                child: Obx(() {
                  return cartController.cartItems.isEmpty
                      ? const Center(child: Text("Your cart is empty!"))
                      : ListView.builder(
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartController.cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                 Hero(tag: uid,
                                  child:  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.imageUrl,
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                    ),
                                  ),),
                            
                                  const SizedBox(width: 12), // Space between image and text
                            
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Name
                                        Text(
                                          item.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                            
                                        const SizedBox(height: 4),
                            
                                        // Price & Size
                                        Row(
                                          children: [
                                          GradientText("\$53.23", gradient: AppColors.appGradientColors, fontSize: 16.36),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Size: ${item.size}",
                                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                                            ),
                                          ],
                                        ),
                            
                                        const SizedBox(height: 8),
                            
                                        // Quantity & Remove Button
                                        Row(
                                          children: [
                                            // Decrease Quantity
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline,size: 24,),
                                              onPressed: () => cartController.decrementQuantity(item.id),
                                            ),
                            
                                            // Quantity Display
                                            Text(
                                              "${item.quantity}",
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                            
                                            // Increase Quantity
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 24,),
                                              onPressed: () => cartController.incrementQuantity(item.id),
                                            ),
                            
                                            const Spacer(),
                            
                                            // Remove Button
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: AppColors.appColor),
                                              onPressed: () => cartController.removeItem(item.id),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                }),
              ),
        
              // Price Summary
              Obx(() {
                return Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:  Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      SummaryRow(title: "Sub Total", amount: cartController.subTotal),
                      SummaryRow(title: "Shipping", amount: cartController.shippingFee),
                      const Divider(thickness: 1),
                      SummaryRow(title: "Total", amount: cartController.total, isBold: true),
                      const SizedBox(height: 60),
            CustomButton(onTap: (){
              Get.toNamed(RouteName.checkoutScreen);
            }, text: "Checkout",),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final double amount;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.title,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01), // 1% of screen width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.05, // 5% of screen width
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: screenWidth * 0.058, // 6% of screen width
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

