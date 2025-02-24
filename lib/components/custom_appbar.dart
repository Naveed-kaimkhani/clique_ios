import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  bool isNotification = false;
  CustomAppBar({super.key, required this.title, this.icon, this.isNotification = false});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive dimensions
    final double appBarHeight = screenHeight * 0.09; // 12% of screen height
    final double iconSize = screenWidth * 0.07; // 7% of screen width
    final double titleFontSize = screenWidth * 0.06; // 6% of screen width
    final double horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final double topPadding = screenHeight * 0.04; // 4% of screen height

    return Container(
      height: appBarHeight,
      width: double.infinity,
      // padding: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
          
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(width: 1,),
            IconButton(
              icon: Icon(
                icon ?? Icons.search_outlined,
                color: Colors.white,
                size: iconSize,
              ),
              onPressed: () {
             (icon != null) ? Get.back():Get.toNamed(RouteName.searchScreen) ;
              },
            ),
            
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                fontFamily: 'ClashDisplay'
              ),
            ),
          isNotification?SizedBox(width: screenWidth *0.1,):  Padding(
              padding: EdgeInsets.only(left: horizontalPadding),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  // Handle notification button press
                  Get.toNamed(RouteName.notificationScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}