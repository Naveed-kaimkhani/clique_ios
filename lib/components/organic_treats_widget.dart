import 'package:clique/components/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_svg_icons.dart';

class OrganicTreatsWidget extends StatelessWidget {
  const OrganicTreatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          AppSvgIcons.bone,
          height: screenHeight * 0.06, // Responsive height
          width: screenWidth * 0.12, // Responsive width
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LabelText(text: "Organic Treats", fontSize: screenWidth * 0.04, ),
            LabelText(
              text: "\$39.00",
              weight: FontWeight.bold,
              fontSize: screenWidth * 0.042, // Responsive font size
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.13, // Responsive height
          width: screenWidth * 0.12, // Responsive width
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Center(
            child: SvgPicture.asset(
              AppSvgIcons.bag,
              height: screenHeight * 0.03, // Responsive height
              width: screenWidth * 0.06, // Responsive width
            ),
          ),
        ),
      ],
    );
  }
}
