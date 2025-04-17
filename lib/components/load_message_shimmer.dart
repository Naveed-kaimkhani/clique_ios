import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadMessageAnimation extends StatelessWidget {
  const LoadMessageAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/chat_loading.json', width: 100),
          SizedBox(height: 16),
          Text(
            "Fetching hot gossip...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}