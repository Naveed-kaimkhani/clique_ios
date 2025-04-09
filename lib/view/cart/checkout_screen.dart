
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/address_dialog_content.dart';
import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/models/order_summary.dart';
import 'package:clique/view/cart/confirm_payment.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:clique/view_model/stripe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class CheckoutController extends GetxController {
  var selectedPayment = ''.obs; // Reactive variable for payment method
  var isFinished = false.obs;
}

class CheckoutScreen extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());
  
  final AddressController addressController = Get.put(AddressController());
final stripeVM = Get.put(StripeViewModel());
final CartQuantityController _cartQuantityController = Get.find<CartQuantityController>();
// CartQuantityController _cartQuantityController = Get.find<CartQuantityController>();

  final OrderViewModel orderViewModel = Get.put(OrderViewModel());
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    OrderSummary? orderSummary = orderViewModel.orderSummary.value; // Get from ViewModel

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
          appBar: 
              CustomAppBar(title: "Checkout ", icon: Icons.arrow_back_ios),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Padding(
                padding: EdgeInsets.only(right: horizontalPadding, left: horizontalPadding, top: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Address', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
                   IconButton(
  icon: Icon(Icons.edit),
  onPressed: () {
    Get.defaultDialog(
      title: "Enter Shipping Address",
      content: AddressDialogContent(),
    );
  },
),

                  ],
                ),
              ),
              // ListTile(
              //   leading: Icon(Icons.location_on),
              //   title: Text('62 High Rd, Wood Green', style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold)),
              //   subtitle: Text('London N22 6DH', style: TextStyle(fontSize: subtitleFontSize)),
              // ),
              ListTile(
  leading: const Icon(Icons.location_on),
  title: Obx(() {
    // Use the AddressController to get the saved address details
    final address = addressController.address1.value;

    return Text(
      '${addressController.address1 ?? "Address not found"}',
      style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold),
    );
  }),
  subtitle: Obx(() {
    final address = addressController.address1.value;

    return Text(
      '${addressController.address2 ?? "Address not found"}, ${addressController.city ?? ""} ${addressController.stateCode ?? ""} ${addressController.zipCode ?? ""}',
      style: TextStyle(fontSize: subtitleFontSize),
    );
  }),
),

              SizedBox(height: verticalPadding),
        
              // Payment Method
              Padding(
                padding: EdgeInsets.only(right: horizontalPadding, left: horizontalPadding),
                child: Text('Payment Method', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPadding * 0.5),
                    child: paymentOption('Master Card', '**** 1234 567', AppSvgIcons.master, 'mastercard'),
                  ),
                  // paymentOption('Apply Pay', '**** 1278 217', AppSvgIcons.apple, 'applepay'),
                  // Padding(
                  //   padding: EdgeInsets.only(left: horizontalPadding * 0.5),
                  //   child: paymentOption('Pay with PayPal', '', AppSvgIcons.payal, 'paypal'),
                  // ),
                ],
              ),
        
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(right: horizontalPadding, left: horizontalPadding),
                child: Text('My Cart', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              ),
        
              // // Cart Items
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
                  children: [
                    cartItem(cartItemSize),
                    // cartItem(cartItemSize),
                    // cartItem(cartItemSize),
                  ],
                ),
              ),

       
              SizedBox(height: screenHeight * 0.1),
              Container(
                padding: EdgeInsets.all(horizontalPadding * 0.5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text((_cartQuantityController.products.first.cost*_cartQuantityController.quantity.value).toString(), style: TextStyle(fontSize: titleFontSize * 1.2, fontWeight: FontWeight.bold)),
                      ],
                    ),
//                       Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Shipping Cost', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey)),
//                         orderViewModel.orderSummary == null
//   ? SizedBox()
//   : Text(
//   (( _cartQuantityController.products.first.cost * _cartQuantityController.quantity.value) + 
//       (int.parse(orderViewModel.orderSummary.value?.shipping??""))).toString(),
//   style: TextStyle(fontSize: titleFontSize * 1.2, fontWeight: FontWeight.bold),
// ),


//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Total Cost', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey)),
//                         orderViewModel.orderSummary == null
//   ? SizedBox()
//   : Text(
//   (( _cartQuantityController.products.first.cost * _cartQuantityController.quantity.value) + 
//       (int.parse(orderViewModel.orderSummary.value?.shipping??""))).toString(),
//   style: TextStyle(fontSize: titleFontSize * 1.2, fontWeight: FontWeight.bold),
// ),


//                       ],
//                     ),
                    SizedBox(height: verticalPadding),
                //     ElevatedButton(onPressed: (){

                //  orderViewModel.submitOrder();
                //     }, child:Text("prsss")),


                    Obx(() => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: SwipeableButtonView(
                        buttonText: "Slide to Pay",
                        buttonWidget: Container(
                          width: 50,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        activeColor: Colors.black,
                        isFinished: controller.isFinished.value,
                    onWaitingProcess: () async {
                      // 
                      
            await     orderViewModel.submitOrder();
  await stripeVM.makePayment( 100); // $63.73 in cents
  controller.isFinished.value = true;
},
                       onFinish: () async {
  if (stripeVM.isLoading.value == false) {
    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const ConfirmationPage(),
        duration: Duration(milliseconds: 500),
      ),
    );
    controller.isFinished.value = false;
  }
},
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentOption(String title, String subtitle, String path, String value) {
    return Obx(() => ListTile(
      leading: Image.asset(path),
      title: Text(title, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey)) : null,
      trailing: Radio(
        value: value,
        groupValue: controller.selectedPayment.value,
        onChanged: (newValue) => controller.selectedPayment.value = newValue.toString(),
        activeColor: Colors.pink,
      ),
    ));
  }

  Widget cartItem(double size) {
    return Padding(
      padding: const EdgeInsets.only(right: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Container(
  height: size,
  width: size,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  child: CachedNetworkImage(
    imageUrl: _cartQuantityController.products.first.imageUrls.first, // Replace with your image URL
    placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder while loading
    errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget
    fit: BoxFit.cover,
  ),
),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Text(
  _cartQuantityController.products.first.productTitle,
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  overflow: TextOverflow.visible, // Make sure it wraps and is visible
  softWrap: true, // Allow wrapping to new lines
),
// SizedBox(
//         width: size * 0.20, // Fixed width
//         height: size * 0.24, // Fixed height
//         child: _buildMarqueeText(_cartQuantityController.products.first.productTitle, size),
//       ),
              // _buildMarqueeText(_cartQuantityController.products.first.productTitle, size), 
              GradientText((_cartQuantityController.products.first.cost*_cartQuantityController.quantity.value).toString(), gradient: AppColors.appGradientColors, fontSize: 14),
            ],
          ),
        ],
      ),
    );
  }
   Widget _buildMarqueeText(String text , double screenWidth) {
  return Marquee(
    text: text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.038,
    ),
    blankSpace: 30.0,
    velocity: 50.0,
    pauseAfterRound: Duration(seconds: 1),
    startPadding: 10.0,
  );
}
}