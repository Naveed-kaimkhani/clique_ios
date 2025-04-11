
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ShopAllWidget extends StatelessWidget {
  const ShopAllWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.06;
    final spacing = screenSize.height * 0.01;

    return    GestureDetector(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppSvgIcons.shoppingBag,
                width: iconSize,
                height: iconSize,
              ),
              SizedBox(height: spacing),
           Center(
            child:    Text(
              "View All",
                style: TextStyle(
                  fontSize: screenSize.width * 0.035,
                ),
              ),
           )
            ],
          ),
          onTap: (){
            Get.toNamed(RouteName.viewAllProductsScreen);
          },
    );
  }
}