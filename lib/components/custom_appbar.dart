import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomAppBar extends PreferredSize {
  final String title;
  final IconData? icon;
  final bool isNotification;

  CustomAppBar({
    super.key,
    required this.title,
    this.icon,
    this.isNotification = false,
  }) : super(
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.3), // Increased height
          child: _CustomAppBarWidget(
            title: title,
            icon: icon,
            isNotification: isNotification,
          ),
        );
}

class _CustomAppBarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isNotification;

  const _CustomAppBarWidget({
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
                  icon ?? Icons.search_outlined,
                  color: Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  icon != null ? Get.back() : Get.toNamed(RouteName.searchScreen);
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
              isNotification 
                ? SizedBox(width: screenWidth * 0.1)
                : IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Get.toNamed(RouteName.notificationScreen);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}