import 'package:clique/controller/size_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants/app_colors.dart';

class SizeSelector extends StatelessWidget {
  final String weight;
    final String unit;
   SizeSelector({super.key, 
   required this.unit
   ,  required this.weight});
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
        _sizeButton(weight,unit, size),
        // _sizeButton("S", size),
        // _sizeButton("M", size),
        // _sizeButton("L", size),
        // _sizeButton("XL", size),
      ],
    );
  }

  Widget _sizeButton(String sizeText, String unit, Size screenSize) {
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
              color:  Colors.red,
               
              width: screenSize.width * 0.004, // 0.3% border width
            ),
          ),
          child: Text(
            "$sizeText $unit",
            style: TextStyle(
              color:  Colors.black,
            
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.03, // 4% of screen width
            ),
          ),
        ),
      ),
    );
  }
}