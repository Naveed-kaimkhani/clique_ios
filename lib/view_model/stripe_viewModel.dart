import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/repositories/payment_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class StripeViewModel extends GetxController {
  var isLoading = false.obs;

  final userController = Get.find<UserController>();
  Future<void> makePayment(double amount) async {
    try {
      isLoading.value = true;

      final clientSecret = await PaymentService.createPaymentIntent(amount, userController.token.value);
     
      log("Client Secret: $clientSecret");

      await Stripe.instance.initPaymentSheet(
      
        paymentSheetParameters: SetupPaymentSheetParameters(
      allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Clique',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      Get.snackbar('Success', 'Payment completed');
    } catch (e) {
      if (e is StripeException) {
        Get.snackbar('Error', e.error.message ?? 'Stripe error');
      } else {
        Get.snackbar('Error', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
}
