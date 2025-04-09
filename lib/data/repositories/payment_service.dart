import 'dart:convert';
import 'dart:developer';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // final userController = Get.find<UserController>();
  static Future<String> createPaymentIntent(double amount , String token) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.stripePaymentApi),
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'amount': amount,   
        "currency": "usd"
        }),
    );
    log("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['clientSecret'];
    } else {
      print(
        "Error: ${response.statusCode} ${response.body}"
      );
    log("Stripe Response: ${response.body}");
      // throw Exception('Failed to create payment intent');
      
      throw Exception('');
    }
  }
}
