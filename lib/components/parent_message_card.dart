import 'package:flutter/material.dart';

class ParentMessageCard extends StatelessWidget {
  final String message;
  final String senderName;

  const ParentMessageCard({
    Key? key,
    required this.message,
    required this.senderName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender Name
          Text(
            senderName,
            style: TextStyle(
              fontSize: size.width * 0.038,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 6),

          // Message Text
          Text(
            message,
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 12),

          // Divider
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
