import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWithBackIcon extends PreferredSize {
  final String title;
  final IconData? icon;
  final bool isNotification;
  
  final IconData? logoutIcon;
  AppBarWithBackIcon({
    super.key,
    required this.title,
    this.logoutIcon,
    
    this.icon,
    this.isNotification = false,
  }) : super(
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.2), // Increased height
          child: _AppBarWithBackIconWidget(
            title: title,
            icon: icon,
            isNotification: isNotification,
          ),
        );
}

class _AppBarWithBackIconWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isNotification;

   _AppBarWithBackIconWidget({
    required this.title,
    this.icon,
    this.isNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.07;
    final titleFontSize = screenWidth * 0.06;
    final horizontalPadding = screenWidth * 0.04;

    return Container(
      height: kToolbarHeight * 1.5, // Increased height
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                 Icons.arrow_back_ios,
                  color: Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                 Get.back() ;
                },
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SofiaPro'
                ),
              ),
              isNotification 
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Get.toNamed(RouteName.productSearchScreen);
                    },
                  )
               
               : SizedBox(width: 52,)
            ],
          ),
        ),
      ),
    );
  }
}