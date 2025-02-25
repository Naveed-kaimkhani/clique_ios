
import 'package:clique/components/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/index.dart';

class PostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppSvgIcons.profile, height: screenWidth * 0.12, width: screenWidth * 0.12),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brian Brunner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                  ),
                  Text(
                    '@brianbrunner',
                    style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: screenWidth * 0.018),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.15),
            child: Text(
              'Please note that some processing of your personal data may not require your consent, but you have a right to object to such processing 😍😍😍...',
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AppImages.product3,
                height: screenWidth * 0.4,
                width: screenWidth * 0.85,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.15),
          
            child: Container(
          height:  screenWidth * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color.fromARGB(255, 226, 224, 224)),
                // gradient: AppColors.appGradientColors
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LabelText(text: "Add to Cart"),
                  GradientText( "Add to Cart", gradient: AppColors.appGradientColors, fontSize: screenWidth*0.04),
                  SizedBox(width: screenWidth*0.1,),
                  SvgPicture.asset(
                    AppSvgIcons.bag, 
                    colorFilter: ColorFilter.mode(AppColors.appColor, BlendMode.srcIn),
                    width: screenWidth * 0.07, 
                    height: screenWidth * 0.07
                  )
               ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
