import 'package:clique/components/label_text.dart';
import 'package:clique/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({super.key, required this.onTap, required this.text});
  
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.06,
        width:screenWidth * 0.8,
        decoration: BoxDecoration(
       color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Centered Text
            LabelText(
              text: text,
              textColor: Colors.white,
              weight: FontWeight.w500,
              fontSize: AppFontSize.small,
            ),

            /// Right Aligned Icon
       
          ],
        ),
      ),
    );
  }
}