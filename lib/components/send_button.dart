import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.14; // Adjust size based on screen width
    final iconSize = buttonSize * 0.5;

    return GestureDetector(
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
          gradient: AppColors.appGradientColors,
          borderRadius: BorderRadius.circular(buttonSize * 0.27),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),   
        child: Padding(
          padding: EdgeInsets.all(buttonSize * 0.14),
          child: Center(
            child: Icon(Icons.send, color: Colors.white, size: iconSize),
          ),
        ),
      ),
    );
  }
}