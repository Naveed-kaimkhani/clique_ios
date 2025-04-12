import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:clique/data/models/address.dart';
import 'package:clique/data/models/order.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/models/order_summary.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:get/get.dart';
import 'package:clique/view_model/address_controller.dart';

  import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderViewModel extends GetxController {
  final AddressController addressController = Get.find<AddressController>();

  // var orderId = ''.obs;
  final CartQuantityController cartQuantityController = Get.find<CartQuantityController>();
  final userController = Get.find<UserController>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<OrderSummary?> orderSummary = Rx<OrderSummary?>(null); // Define the orderSummary field

Future<OrderSummary?> submitOrder() async {
 
  try {
    isLoading.value = true;

    // Prepare the order data using the Address Controller
    if (addressController.address1.isEmpty) {
        Get.snackbar("Error", "Please enter address");
    }
    var address = Address(
      address1: addressController.address1.value,
      address2: addressController.address2.value,
      city: addressController.city.value,
      stateCode: addressController.stateCode.value,
      countryCode: addressController.countryCode.value,
      zipCode: addressController.zipCode.value,
    );

    var order = Order(
      customerId: userController.uid.toString(), // Use the actual customer ID
      firstName: userController.userName.value, // Use the actual first name
      lastName: "", // Use the actual last name
      phone: userController.phone.value, // Use the actual phone number
      address: address,
      transactions: [
        Transaction(
          tdid: cartQuantityController.products.first.tdid ?? "",
          quantity: cartQuantityController.quantity.value,
        )
      ],
      productDetails: [
        ProductModel(

          id: cartQuantityController.products.first.id,
          productWeight: cartQuantityController.products.first.productWeight,
          productCode: cartQuantityController.products.first.productCode,
          unit: cartQuantityController.products.first.unit,
          productTitle: cartQuantityController.products.first.productTitle,
          productDesc: cartQuantityController.products.first.productDesc,
          imageUrls: cartQuantityController.products.first.imageUrls,
          cost: cartQuantityController.products.first.cost,
          brandName: "",
          msrp: 0,
          thumbnailUrl: "",
          categories: "",
          variantGroupId: "",
        )
      ],
    );

    // Send POST request to the API
    // final url = Uri.parse(ApiEndpoints.createOrderApi);

    final url = Uri.parse("https://cactisocial.com/api-clique/public/api/v1/topdawg/orders");

    // final token = 'your_bearer_token';  // Replace with actual token

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userController.token.value}',
    };

    // Prepare the request body by converting the order object to a map
    final Map<String, dynamic> orderMap = order.toMap(); // Log the JSON string
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(orderMap),  // Encode the order map to JSON
    
    );
    log(response.body);
    if (response.statusCode == 200) {
      // Success
    final parsedOrderSummary = OrderSummary.fromJson(jsonDecode(response.body));
 
        orderSummary.value = parsedOrderSummary;
        return parsedOrderSummary;
    } else {
      // Failure
      Utils.showCustomSnackBar("Error", "Failed to place order", ContentType.failure);
 
    }
  } catch (e) {
     Utils.showCustomSnackBar("Error", "Failed to place order $e", ContentType.failure);
 
  } finally {
    isLoading.value = false;
  }
}
Future<void> processOrder(String orderId) async {
  try {
    isLoading.value = true;

    final url = Uri.parse("https://cactisocial.com/api-clique/public/api/v1/topdawg/orders/process");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userController.token.value}',
    };

    final body = jsonEncode({
      "order_id": orderId,
    });

    final response = await http.post(url, headers: headers, body: body);
    log('Process Order Response: ${response.body}');

    if (response.statusCode == 200) {
      Utils.showCustomSnackBar("Success", "Order processed successfully", ContentType.success);
    } else {
      Utils.showCustomSnackBar("Error", "Failed to process order", ContentType.failure);
    }
  } catch (e) {
    Utils.showCustomSnackBar("Exception", "Error while processing order: $e", ContentType.failure);
  } finally {
    isLoading.value = false;
  }
}

}
