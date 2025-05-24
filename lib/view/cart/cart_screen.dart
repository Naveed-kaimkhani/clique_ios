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
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBarWithBackIcon(
          title: "My Cart",
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                final products = cartQuantityController.products;
                if (products.isEmpty) {
                  return _buildEmptyCart();
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Dismissible(
                      key: Key(product.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: _buildDeleteBackground(),
                      confirmDismiss: (direction) async {
                        return await _showDeleteDialog(product.id.toString());
                      },
                      onDismissed: (direction) {
                        cartQuantityController
                            .removeFromCart(product.id.toString());
                      },
                      child: _buildCartItem(product),
                    );
                  },
                );
              }),
            ),
            _buildCheckoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/empty_cart.png', // Add this asset to your project
          //   width: 150,
          //   height: 150,
          // ),
          // const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Browse our products and add some items!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          AuthButton(
            buttonText: "Continue Shopping",
            onPressed: () {
              Get.back(); // Or navigate to your products screen
            },
            isLoading: false.obs,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child:
                        Container(width: 84, height: 84, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.productTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () =>
                            _showDeleteDialog(product.id.toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GradientText(
                    "\$${product.cost.toStringAsFixed(2)}",
                    gradient: AppColors.appGradientColors,
                    fontSize: 16.36,
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cartQuantityController
                                .decrementQuantity(product.id.toString()),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${cartQuantityController.getQuantity(product.id.toString())}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cartQuantityController
                                .incrementQuantity(product.id.toString()),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.red,
        size: 30,
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Divider(thickness: 1),
          Obx(() => SummaryRow(
                title: "Sub Total",
                amount: cartQuantityController.getSubTotal(),
                isBold: true,
              )),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          cartQuantityController.products.isEmpty
              ? SizedBox()
              : AuthButton(
                  buttonText: "Proceed to Checkout",
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
                ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(String productId) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Item"),
        content: const Text(
            "Are you sure you want to remove this item from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              cartQuantityController.removeFromCart(productId);
            },
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearCartDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart"),
        content: const Text(
            "Are you sure you want to remove all items from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              cartQuantityController.clearCart();
            },
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
