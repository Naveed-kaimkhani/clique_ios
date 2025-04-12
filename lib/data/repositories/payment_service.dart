import 'dart:convert';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

class PaymentService { 
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

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['client_secret'];
    } else {
     
      throw Exception('Failed to create payment intent');
      
    }
  }
}
