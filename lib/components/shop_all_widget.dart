import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShopAllWidget extends StatelessWidget {
  // final VoidCallback onTap; // 👈 add this
    final PopstreamModel popstream;

  const ShopAllWidget({
    // required this.onTap, // 👈 add this
    required this.popstream,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.06;
    final spacing = screenSize.height * 0.01;

    return Column(
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
          child: Text(
            "View All",
            style: TextStyle(
              fontSize: screenSize.width * 0.035,
            ),
          ),
        )
      ],
    );
  }
}
