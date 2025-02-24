
import 'package:clique/components/organic_treats_widget.dart';
import 'package:clique/components/shop_all_widget.dart';
import 'package:flutter/material.dart';

class ShoppingWidget extends StatelessWidget {
  const ShoppingWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: screenHeight * 0.12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.14,
            width: screenWidth * 0.2,
            padding: EdgeInsets.all(screenWidth * 0.02),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: ShopAllWidget(),
          ),
          Container(
            height: screenHeight * 0.14,
            width: screenWidth * 0.65,
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: OrganicTreatsWidget(),
          ),
        ],
      ),
    );
  }
}
