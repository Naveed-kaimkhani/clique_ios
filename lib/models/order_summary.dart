
// class OrderSummary {
//   final int orderId;
//   final String shipping;

//   OrderSummary({
//     required this.orderId,
//     required this.shipping,
//   });

//   factory OrderSummary.fromJson(Map<String, dynamic> json) {
//     return OrderSummary(
//       orderId: int.parse(json['order_details']['order_id'].toString()), // Parsing order_id as an integer
//       shipping: json['order_details']['shipping'],
//     );
//   }
// }

class OrderSummary {
  final int orderId;
  final String shipping;

  OrderSummary({
    required this.orderId,
    required this.shipping,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      orderId: 0, // Dummy value
      shipping: json['amount'].toString(), // Use 'amount' from response
    );
  }
}
