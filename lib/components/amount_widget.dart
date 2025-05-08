import 'package:flutter/material.dart';

class AmountWidget extends StatelessWidget {
  final String label;
   var value;
  final double titleFontSize;

  AmountWidget({
    required this.label,
    required this.value,
    required this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      Text(
  "\$${value.toStringAsFixed(2)}",
  style: TextStyle(
    fontSize: titleFontSize * 1.0,
    fontWeight: FontWeight.bold,
  ),
),

      ],
    );
  }
}
