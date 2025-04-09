import 'package:clique/data/models/address.dart';
import 'package:clique/data/models/product_model.dart';

class Order {
  final String customerId;
  final String firstName;
  final String lastName;
  final String phone;
  final Address address;
  final List<Transaction> transactions;
  final List<ProductModel> productDetails;

  Order({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.transactions,
    required this.productDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      "customer": {
        "customer_id": customerId,
        "first_name": firstName,
        "last_name": firstName,
        "phone": phone,
      },
      "address_to": address.toMap(),
      "transactions": transactions.map((e) => e.toMap()).toList(),
      "product_details": productDetails.map((e) => e.toMap()).toList(),
    };
  }
}

class Transaction {
  final String tdid;
  final int quantity;

  Transaction({required this.tdid, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      "tdid": tdid,
      "quantity": quantity,
    };
  }
}
