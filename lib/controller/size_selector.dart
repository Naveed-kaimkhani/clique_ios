import 'package:clique/controller/size_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/app_colors.dart';

class SizeSelector extends StatelessWidget {
  final SizeController sizeController = Get.put(SizeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Text(
          "Size",
          style: TextStyle(
            fontSize: size.width * 0.048, // 5% of screen width
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: size.width * 0.02), // 2% spacing
        _sizeButton("XS", size),
        _sizeButton("S", size),
        _sizeButton("M", size),
        _sizeButton("L", size),
        _sizeButton("XL", size),
      ],
    );
  }

  Widget _sizeButton(String sizeText, Size screenSize) {
    return Obx(
      () => GestureDetector(
        onTap: () => sizeController.selectSize(sizeText),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01), // 1% spacing
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.008, // 1% of screen height
            horizontal: screenSize.width * 0.03, // 4% of screen width
          ),
          decoration: BoxDecoration(
            gradient: sizeController.selectedSize.value == sizeText
                ? AppColors.appGradientColors
                : null,
            borderRadius: BorderRadius.circular(screenSize.width * 0.02), // 2% border radius
            border: Border.all(
              color: sizeController.selectedSize.value == sizeText
                  ? Colors.red
                  : Colors.grey,
              width: screenSize.width * 0.006, // 0.3% border width
            ),
          ),
          child: Text(
            sizeText,
            style: TextStyle(
              color: sizeController.selectedSize.value == sizeText
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.03, // 4% of screen width
            ),
          ),
        ),
      ),
    );
  }
}