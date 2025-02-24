import 'package:clique/components/label_text.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShopAllWidget extends StatelessWidget {
  const ShopAllWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppSvgIcons.shoppingBag),
            // Icon(Icons.shopping_bag_outlined)
            LabelText(text: "Shop All"),
          ],
       ),
     
      ],
    );
  }
}