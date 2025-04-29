import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/amount_widget.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/discover/appBar_backicon.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:clique/view_model/stripe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var selectedPayment = ''.obs; // Reactive variable for payment method
  var isFinished = false.obs;
}

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController controller = Get.put(CheckoutController());

  final AddressController addressController = Get.find();

  final stripeVM = Get.put(StripeViewModel());

// final CartQuantityController _cartQuantityController = Get.find<CartQuantityController>();
  final CartQuantityController _cartQuantityController =
      Get.isRegistered<CartQuantityController>()
          ? Get.find<CartQuantityController>()
          : Get.put(CartQuantityController());

  final StripeViewModel stripeViewModel = Get.put(StripeViewModel());

  final OrderViewModel orderViewModel = Get.put(OrderViewModel());
  @override
  void dispose() {
    // Delete the cart controller when screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // double subTotal = (_cartQuantityController.products.first.cost *
    //     _cartQuantityController.quantity.value);
    double subTotal = _cartQuantityController.getSubTotal();
    // Define responsive padding and font sizes
    final double horizontalPadding = screenWidth * 0.06; // 6% of screen width
    final double verticalPadding = screenHeight * 0.02; // 2% of screen height
    final double titleFontSize = screenWidth * 0.05; // 5% of screen width
    final double subtitleFontSize = screenWidth * 0.04; // 4% of screen width
    final double cartItemSize = screenWidth * 0.2; // 20% of screen width

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWithBackIcon(
            title: "Checkout",
            // icon: Icons.arrow_back_ios,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Padding(
                padding: EdgeInsets.only(
                    right: horizontalPadding,
                    left: horizontalPadding,
                    top: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Address',
                        style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.toNamed(
                          RouteName.addressScreen,
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Obx(() {
                  // Use the AddressController to get the saved address details
                  final address = addressController.address1.value;

                  return Text(
                    '${addressController.address1}',
                    style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold),
                  );
                }),
                subtitle: Obx(() {
                  final address = addressController.address1.value;

                  return Text(
                    '${addressController.address2} ${addressController.city } ${addressController.stateCode} ${addressController.zipCode ?? ""}',
                    style: TextStyle(fontSize: subtitleFontSize),
                  );
                }),
              ),

              SizedBox(height: verticalPadding),

              // Payment Method
              Padding(
                padding: EdgeInsets.only(
                    right: horizontalPadding, left: horizontalPadding),
                child: Text('Payment Method',
                    style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() {
                    final summary = orderViewModel.orderSummary.value;
                    final shippingCost = summary != null
                        ? double.tryParse(summary.shipping) ?? 0.0
                        : 0.0;

                    return Padding(
                      padding: EdgeInsets.only(left: horizontalPadding * 0.5),
                      child: paymentOption(
                          subTotal + shippingCost,
                          'Add Card Details',
                          '**** *****',
                          AppSvgIcons.master,
                          'mastercard'),
                    );
                  }),
                ],
              ),

              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(
                    right: horizontalPadding, left: horizontalPadding),
                child: Text('My Cart',
                    style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    right: horizontalPadding, left: horizontalPadding),
                child: cartItem(cartItemSize),
              ),
              Spacer(),

              SizedBox(height: screenHeight * 0.1),
              Container(
                padding: EdgeInsets.all(horizontalPadding * 0.5),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    AmountWidget(
                      label: 'Sub Total',
                      value: subTotal,
                      titleFontSize: titleFontSize,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Obx(() {
                      final summary = orderViewModel.orderSummary.value;
                      final shippingCost = summary != null
                          ? double.tryParse(summary.shipping) ?? 0.0
                          : 0.0;

                      return addressController.address1.value.isNotEmpty
                          ? AmountWidget(
                              label: 'Shipping',
                              value: shippingCost,
                              titleFontSize: titleFontSize,
                            )
                          : AmountWidget(
                              label: 'Shipping',
                              value: 0.0,
                              titleFontSize: titleFontSize,
                            );
                    }),
                    SizedBox(height: screenHeight * 0.01),
                    Obx(() {
                      final summary = orderViewModel.orderSummary.value;
                      final shippingCost = summary != null
                          ? double.tryParse(summary.shipping) ?? 0.0
                          : 0.0;

                      return AmountWidget(
                        label: 'Total',
                        value: subTotal + shippingCost,
                        titleFontSize: titleFontSize,
                      );
                    }),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentOption(
      double total, String title, String subtitle, String path, String value) {
    return Obx(() => ListTile(
          onTap: () {
            if (addressController.address1.value.isEmpty) {
              Utils.showCustomSnackBar(
                  "Info", "Enter Shipping Address", ContentType.warning);
            } else {
              stripeViewModel.makePayment(total * 100);
            }
          },
          leading: Image.asset(path),
          title: Text(title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          subtitle: subtitle.isNotEmpty
              ? Text(subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey))
              : null,
          trailing: Radio(
            value: value,
            groupValue: controller.selectedPayment.value,
            onChanged: (newValue) {
              if (addressController.address1.value.isEmpty) {
                Utils.showCustomSnackBar(
                    "Info", "Enter Shipping Address", ContentType.warning);
              } else {
                controller.selectedPayment.value = newValue.toString();
                stripeViewModel.makePayment(total * 100);
              }
            },
            activeColor: Colors.pink,
          ),
        ));
  }

  // Widget cartItem(double size) {
  Widget cartItem(double size) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    _cartQuantityController.products.first.imageUrls.first,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 1.5)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    _cartQuantityController.products.first.productTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    GradientText(
                      (_cartQuantityController.products.first.cost)
                          .toStringAsFixed(2),
                      gradient: AppColors.appGradientColors,
                      fontSize: 14,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GradientText(
                      "x",
                      gradient: AppColors.appGradientColors,
                      fontSize: 14,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    // GradientText(
                    //   (_cartQuantityController.getQuantity()).toString(),
                    //   gradient: AppColors.appGradientColors,
                    //   fontSize: 14,
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
