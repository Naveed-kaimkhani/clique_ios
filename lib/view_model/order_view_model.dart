

import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/controller/user_controller.dart';
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
  final AddressController addressController = 
    Get.find<AddressController>();
    



  var stateCode = ''.obs;
  
  var city = ''.obs;
  final CartQuantityController cartQuantityController = Get.find<CartQuantityController>();
  final userController = Get.find<UserController>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<OrderSummary?> orderSummary = Rx<OrderSummary?>(null); // Define the orderSummary field


Future<OrderSummary?> submitOrderFromCart() async {
  try {
    isLoading.value = true;

    // Check if address is empty
    if (addressController.address1.isEmpty) {
      Get.snackbar("Error", "Please enter address");
      return null;
    }

    // Prepare the address and order
    var address = Address(
      address1: addressController.address1.value,
      address2: addressController.address2.value,
      city: addressController.city.value,
      stateCode: addressController.stateCode.value,
      countryCode: 'US',
      zipCode: addressController.zipCode.value,
    );

    var order = Order(
      customerId: userController.uid.toString(),
      firstName: userController.userName.value,
      lastName: "",
      phone: userController.phone.value,
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

    final url = Uri.parse("https://cactisocial.com/api-clique/public/api/v1/topdawg/orders");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userController.token.value}',
    };

    final Map<String, dynamic> orderMap = order.toMap();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(orderMap),
    );

    log(response.body);

    if (response.statusCode == 200) {
      final parsedOrderSummary = OrderSummary.fromJson(jsonDecode(response.body));
      orderSummary.value = parsedOrderSummary;
      return parsedOrderSummary;
    } else {
      // Decode error and extract meaningful message
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      String userErrorMessage = "Failed to place order";

      if (errorBody.containsKey('response') && errorBody['response']['messages'] != null) {
        final messages = errorBody['response']['messages'];
        String allErrors = "";

        messages.forEach((key, value) {
          final errors = value['error'];
          if (errors != null && errors.isNotEmpty) {
            allErrors += "${errors[0]}\n";
          }
        });

        userErrorMessage = allErrors.trim();
      }

      Utils.showCustomSnackBar("Error", userErrorMessage, ContentType.failure);
      return null;
    }
  } catch (e) {
    Utils.showCustomSnackBar("Error", "Failed to place order: $e", ContentType.failure);
    return null;
  } finally {
    isLoading.value = false;
  }
}


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
      city: city.value,
      stateCode: stateCode.value,
      countryCode: 'US',
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
      // Decode error and extract meaningful message
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      String userErrorMessage = "Failed to place order";

      if (errorBody.containsKey('response') && errorBody['response']['messages'] != null) {
        final messages = errorBody['response']['messages'];
        String allErrors = "";

        messages.forEach((key, value) {
          final errors = value['error'];
          if (errors != null && errors.isNotEmpty) {
            allErrors += "${errors[0]}\n";
          }
        });

        userErrorMessage = allErrors.trim();
      }

      Utils.showCustomSnackBar("Error", userErrorMessage, ContentType.failure);
      return null;
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