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
  final AddressController addressController = Get.find<AddressController>();

  var stateCode = ''.obs;

  var city = ''.obs;
  final CartQuantityController cartQuantityController =
      Get.find<CartQuantityController>();
  final userController = Get.find<UserController>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<OrderSummary?> orderSummary =
      Rx<OrderSummary?>(null); // Define the orderSummary field

  Future<OrderSummary?> submitOrderFromCart() async {
    try {
      isLoading.value = true;

      if (addressController.address1.isEmpty) {
        Get.snackbar("Error", "Please enter address");
        return null;
      }

      var address = Address(
        address1: addressController.address1.value,
        address2: addressController.address2.value,
        city: addressController.city.value,
        stateCode: addressController.stateCode.value,
        countryCode: 'US',
        zipCode: addressController.zipCode.value,
      );
      // Map each product to Transaction and ProductModel
      List<Transaction> transactions =
          cartQuantityController.products.map((product) {
        return Transaction(
          tdid: product.tdid ?? "",
          quantity: cartQuantityController.getQuantity(
              product.id.toString()), // ensure quantity is tracked per product
        );
      }).toList();

      List<ProductModel> productDetails =
          cartQuantityController.products.map((product) {
        return ProductModel(
          id: product.id,
          productWeight: product.productWeight,
          productCode: product.productCode,
          unit: product.unit,
          productTitle: product.productTitle,
          productDesc: product.productDesc,
          imageUrls: product.imageUrls,
          cost: product.cost,
          brandName: "",
          msrp: 0,
          tdid: product.tdid,
          thumbnailUrl: "",
          categories: "",
          variantGroupId: "",
        );
      }).toList();

      var order = Order(
        customerId: userController.uid.toString(), // Use the actual customer ID
        firstName: userController.userName.value, // Use the actual first name
        lastName: "", // Use the actual last name
        phone: userController.phone.value, // Use the actual phone number
        address: address,
        transactions: transactions,

        productDetails: productDetails,
      );
      // return OrderSummary.fromJson({});

      final url = Uri.parse(
          "https://cactisocial.com/api-clique/public/api/v1/topdawg/orders");
      final headers = {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer ${userController.token.value}',
      };

      final Map<String, dynamic> orderMap = order.toMap();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(orderMap),
      );

      if (response.statusCode == 200) {
        final parsedOrderSummary =
            OrderSummary.fromJson(jsonDecode(response.body));

        orderSummary.value = parsedOrderSummary;
        return parsedOrderSummary;
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        String userErrorMessage = "Failed to place order";

        if (errorBody.containsKey('response') &&
            errorBody['response']['messages'] != null) {
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

        Utils.showCustomSnackBar(
            "Error", userErrorMessage, ContentType.failure);
        return null;
      }
    } catch (e) {
      Utils.showCustomSnackBar(
          "Error", "Failed to place order: $e", ContentType.failure);
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

      // Map each product to Transaction and ProductModel
      List<Transaction> transactions =
          cartQuantityController.products.map((product) {
        return Transaction(
          tdid: product.tdid ?? "",
          quantity: cartQuantityController.getQuantity(
              product.id.toString()), // ensure quantity is tracked per product
        );
      }).toList();

      List<ProductModel> productDetails =
          cartQuantityController.products.map((product) {
        return ProductModel(
          id: product.id,
          productWeight: product.productWeight,
          productCode: product.productCode,
          tdid: product.tdid,
          unit: product.unit,
          productTitle: product.productTitle,
          productDesc: product.productDesc,
          imageUrls: product.imageUrls,
          cost: product.cost,
          brandName: "",
          msrp: 0,
          thumbnailUrl: "",
          categories: "",
          variantGroupId: "",
        );
      }).toList();

      var order = Order(
          customerId:
              userController.uid.toString(), // Use the actual customer ID
          firstName: userController.userName.value, // Use the actual first name
          lastName: "", // Use the actual last name
          phone: userController.phone.value, // Use the actual phone number
          address: address,
          transactions: transactions,
          productDetails: productDetails);

      final url = Uri.parse(
          "https://cactisocial.com/api-clique/public/api/v1/topdawg/orders");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userController.token.value}',
      };

      // Prepare the request body by converting the order object to a map
      final Map<String, dynamic> orderMap =
          order.toMap(); // Log the JSON string

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(orderMap), // Encode the order map to JSON
      );
      if (response.statusCode == 200) {
        // Success
        final parsedOrderSummary =
            OrderSummary.fromJson(jsonDecode(response.body));

        orderSummary.value = parsedOrderSummary;
        return parsedOrderSummary;
      } else {
        // Decode error and extract meaningful message
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        String userErrorMessage = "Failed to place order";

        if (errorBody.containsKey('response') &&
            errorBody['response']['messages'] != null) {
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

        Utils.showCustomSnackBar(
            "Error", userErrorMessage, ContentType.failure);
        return null;
      }
    } catch (e) {
      Utils.showCustomSnackBar(
          "Error", "Failed to place order $e", ContentType.failure);
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderSummary?> calculateShippingcost() async {
    try {
      isLoading.value = true;

      // Validate required fields
      if (addressController.address1.isEmpty) {
        Get.snackbar("Error", "Please enter address");
        return null;
      }

      // Build request body
      final body = {
        "tdid": cartQuantityController.products.first.tdid,
        "first_name": userController.userName.value,
        "last_name": userController.userName.value,
        "phone": userController.phone.value,
        "address_1": addressController.address1.value,
        "address_2": addressController.address2.value,
        "city": city.value,
        "state_code": stateCode.value,
        "country_code": "US",
        "country": "US",
        "zip_code": addressController.zipCode.value,
      };

      final url = Uri.parse(
          "https://topdawg.com/api/TDApi/ShippingCostEstimator/create");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNThhMDFjMzEzNjJjMGJiMWM3NTAzYjE2ZDcxNTBiMjM1ZWVlNzBhOGEwZDk2YzM1Yzk1NDE1N2QxYzA3ZmY5MjFhYzQ5MjRjODU0MmIxNzAiLCJpYXQiOjE3NDMxODg5NDAuNjExMDI5LCJuYmYiOjE3NDMxODg5NDAuNjExMDMzLCJleHAiOjIwNTg3MjE3NDAuNjA1MDQ3LCJzdWIiOiI0ODMwNSIsInNjb3BlcyI6WyJTaGlwcGluZ0Nvc3RFc3RpbWF0b3IiLCJSZXNlbGxlck9yZGVycyIsIlJlc2VsbGVyUGFyY2VscyIsIlJlc2VsbGVyQ3VzdG9tZXJzIiwiUmVzZWxsZXJQYXltZW50cyIsIlJlc2VsbGVyUHJvZHVjdHMiXX0.Dx1eEDJtGYilgHrs12RAvFj_lVXdc0mwth0eYJ8x2gPfjOsPdYJ9iY7qVafma7jsqg_TV5IJjmRpclSeECjwHe5l4PBzpBCPUlVaCOXyBeIeAaIvJz4ZdiMDJI0H6qyUjPBjBuHxXcVVNXYRwgw-pX-cqA6Q1RbIRmjsC-eNZwUp43XR6O5G4Ych0rwNncnYw0x7NZf1ewl1MGP9fAII7FcmKI77vjPReDJ8T76iaXC9ZR0PxXZe7czT0yezFzJMEkhgJ4dhnJ3K0TJfWq0IEw9VwZqtI00W7Q2mXs_3dRy7U7p_spcCJRZsMYs6JjG19-dCLyCCYhzlXAA5pBVhiwZGNRkR4C5A8pv7FKVFiEbHorr9GxX2BuGfwQycD4VzogzhfP7GGbDxPLYOkaNmAgp1kvQMvkMjgvo1S34L8rhYqHD7cVqCBNQP06dQlAThCMUhXkIGpj154IItgYrZaP-R2U_wvu6YBBc3KRTr1Xx9fAqP-iK4AKyRC49BnAEzbDTZ56OChEOtLanjoyqXXQm7zJTNSR_0t8--m5O-2V9iNsvVfc4Zay4KgYA-jBzFkUgLwPfH0vwb8IlxVXegofyp5MmuzQFRLjhMAWXpGqiZgMqxiqaHa_oL8iiSjH2LCGBH8_IZFTtcOjlogUsrtlyKFN1ktQk5P6gCtz9yClo', // Replace with secure handling
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log(response.body);

      if (response.statusCode == 200) {
        final parsedOrderSummary =
            OrderSummary.fromJson(jsonDecode(response.body));
        orderSummary.value = parsedOrderSummary;
        return parsedOrderSummary;
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        String userErrorMessage = "Failed to place order";

        if (errorBody.containsKey('response') &&
            errorBody['response']['messages'] != null) {
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

        Utils.showCustomSnackBar(
            "Error", userErrorMessage, ContentType.failure);
        return null;
      }
    } catch (e) {
      Utils.showCustomSnackBar(
          "Error", "Failed to place order $e", ContentType.failure);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderSummary?> calculateShippingCostFromCart() async {
    try {
      isLoading.value = true;

      // Validate required fields
      if (addressController.address1.isEmpty) {
        Get.snackbar("Error", "Please enter address");
        return null;
      }

      // Build request body
      final body = {
        "tdid": cartQuantityController.products.first.tdid,
        "first_name": userController.userName.value,
        "last_name": userController.userName.value,
        "phone": userController.phone.value,
        "address_1": addressController.address1.value,
        "address_2": addressController.address2.value,
        "city": addressController.city.value,
        "state_code": addressController.stateCode.value,
        "country_code": "US",
        "country": "US",
        "zip_code": addressController.zipCode.value,
      };

      final url = Uri.parse(
          "https://topdawg.com/api/TDApi/ShippingCostEstimator/create");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNThhMDFjMzEzNjJjMGJiMWM3NTAzYjE2ZDcxNTBiMjM1ZWVlNzBhOGEwZDk2YzM1Yzk1NDE1N2QxYzA3ZmY5MjFhYzQ5MjRjODU0MmIxNzAiLCJpYXQiOjE3NDMxODg5NDAuNjExMDI5LCJuYmYiOjE3NDMxODg5NDAuNjExMDMzLCJleHAiOjIwNTg3MjE3NDAuNjA1MDQ3LCJzdWIiOiI0ODMwNSIsInNjb3BlcyI6WyJTaGlwcGluZ0Nvc3RFc3RpbWF0b3IiLCJSZXNlbGxlck9yZGVycyIsIlJlc2VsbGVyUGFyY2VscyIsIlJlc2VsbGVyQ3VzdG9tZXJzIiwiUmVzZWxsZXJQYXltZW50cyIsIlJlc2VsbGVyUHJvZHVjdHMiXX0.Dx1eEDJtGYilgHrs12RAvFj_lVXdc0mwth0eYJ8x2gPfjOsPdYJ9iY7qVafma7jsqg_TV5IJjmRpclSeECjwHe5l4PBzpBCPUlVaCOXyBeIeAaIvJz4ZdiMDJI0H6qyUjPBjBuHxXcVVNXYRwgw-pX-cqA6Q1RbIRmjsC-eNZwUp43XR6O5G4Ych0rwNncnYw0x7NZf1ewl1MGP9fAII7FcmKI77vjPReDJ8T76iaXC9ZR0PxXZe7czT0yezFzJMEkhgJ4dhnJ3K0TJfWq0IEw9VwZqtI00W7Q2mXs_3dRy7U7p_spcCJRZsMYs6JjG19-dCLyCCYhzlXAA5pBVhiwZGNRkR4C5A8pv7FKVFiEbHorr9GxX2BuGfwQycD4VzogzhfP7GGbDxPLYOkaNmAgp1kvQMvkMjgvo1S34L8rhYqHD7cVqCBNQP06dQlAThCMUhXkIGpj154IItgYrZaP-R2U_wvu6YBBc3KRTr1Xx9fAqP-iK4AKyRC49BnAEzbDTZ56OChEOtLanjoyqXXQm7zJTNSR_0t8--m5O-2V9iNsvVfc4Zay4KgYA-jBzFkUgLwPfH0vwb8IlxVXegofyp5MmuzQFRLjhMAWXpGqiZgMqxiqaHa_oL8iiSjH2LCGBH8_IZFTtcOjlogUsrtlyKFN1ktQk5P6gCtz9yClo', // Replace with secure handling
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log(response.body);

      if (response.statusCode == 200) {
        final parsedOrderSummary =
            OrderSummary.fromJson(jsonDecode(response.body));
        orderSummary.value = parsedOrderSummary;
        return parsedOrderSummary;
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        String userErrorMessage = "Failed to place order";

        if (errorBody.containsKey('response') &&
            errorBody['response']['messages'] != null) {
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

        Utils.showCustomSnackBar(
            "Error", userErrorMessage, ContentType.failure);
        return null;
      }
    } catch (e) {
      Utils.showCustomSnackBar(
          "Error", "Failed to place order $e", ContentType.failure);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> processOrder(String orderId) async {
  //   try {
  //     isLoading.value = true;

  //     final url = Uri.parse(
  //         "https://cactisocial.com/api-clique/public/api/v1/topdawg/orders/process");

  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${userController.token.value}',
  //     };

  //     final body = jsonEncode({
  //       "order_id": orderId,
  //     });

  //     final response = await http.post(url, headers: headers, body: body);

  //     if (response.statusCode == 200) {
  //       Utils.showCustomSnackBar(
  //           "Success", "Order processed successfully", ContentType.success);
  //     } else {
  //       Utils.showCustomSnackBar(
  //           "Error", "Failed to process order", ContentType.failure);
  //     }
  //   } catch (e) {
  //     Utils.showCustomSnackBar(
  //         "Exception", "Error while processing order: $e", ContentType.failure);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
