


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final RxBool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fixedWidth;

  const AuthButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.isLoading,
    this.backgroundColor,
    this.textColor,
    this.fixedWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;
    
    // Responsive sizing
    final buttonHeight = isDesktop ? 50.0 : 50.0;
    final buttonWidth = fixedWidth ?? (isDesktop ? 400.0 : screenSize.width * 0.9);
    final fontSize = isDesktop ? 12.0 : 14.0;
    final spinnerSize = isDesktop ? 24.0 : 20.0;
    final horizontalPadding = isDesktop ? 32.0 : 24.0;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Obx(() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.black,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0, // Important for web to avoid flashy hover effects
        ),
        onPressed: onPressed,
        child: isLoading.value
            ? SpinKitChasingDots(
                color: textColor ?? Colors.white,
                size: spinnerSize,
              )
            : Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
      )),
    );
  }
}