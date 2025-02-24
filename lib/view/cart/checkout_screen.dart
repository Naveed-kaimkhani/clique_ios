


import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/custom_button.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/view/cart/confirm_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class CheckoutController extends GetxController {
  var selectedPayment = ''.obs; // Reactive variable for payment method
  var isFinished = false.obs;
}

class CheckoutScreen extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive padding and font sizes
    final double horizontalPadding = screenWidth * 0.06; // 6% of screen width
    final double verticalPadding = screenHeight * 0.02; // 2% of screen height
    final double titleFontSize = screenWidth * 0.05; // 5% of screen width
    final double subtitleFontSize = screenWidth * 0.04; // 4% of screen width
    final double cartItemSize = screenWidth * 0.2; // 20% of screen width

    return Container(
        color: Colors.black,
      child: SafeArea(
        child: Scaffold(
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
                    IconButton(onPressed: (){}, icon: 
                    Icon(Icons.edit),)
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('62 High Rd, Wood Green', style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('London N22 6DH', style: TextStyle(fontSize: subtitleFontSize)),
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
                  paymentOption('Apply Pay', '**** 1278 217', AppSvgIcons.apple, 'applepay'),
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPadding * 0.5),
                    child: paymentOption('Pay with PayPal', '', AppSvgIcons.payal, 'paypal'),
                  ),
                ],
              ),
        
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(right: horizontalPadding, left: horizontalPadding),
                child: Text('My Cart', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              ),
        
              // Cart Items
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
                  children: [
                    cartItem(cartItemSize),
                    cartItem(cartItemSize),
                    cartItem(cartItemSize),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
        
              // Total Amount
              Container(
                padding: EdgeInsets.all(horizontalPadding * 0.5),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text('\$63.73', style: TextStyle(fontSize: titleFontSize * 1.2, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: verticalPadding),
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
                        onWaitingProcess: () {
                          Future.delayed(Duration(seconds: 1), () {
                            controller.isFinished.value = true;
                          });
                        },
                        onFinish: () async {
                          await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const ConfirmationPage(),
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                          controller.isFinished.value = false;
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
              image: DecorationImage(image: AssetImage(AppSvgIcons.cloth), fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Jacket\nBoucle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GradientText('\$53.23', gradient: AppColors.appGradientColors, fontSize: 14),
            ],
          ),
        ],
      ),
    );
  }
}