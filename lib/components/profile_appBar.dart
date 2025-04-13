import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSAppBar extends PreferredSize {
  final String title;
  final IconData? icon;
  final bool isInfluencer;
  
  final IconData? logoutIcon;
  ProfileSAppBar({
    super.key,
    required this.title,
    this.logoutIcon,
    
    this.icon,
   this.isInfluencer = false,
  }) : super(
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.2), // Increased height
          child: _ProfileSAppBarWidget(
            title: title,
            icon: icon,
            isNotification: isInfluencer,
          ),
        );
}
class _ProfileSAppBarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isNotification;

  _ProfileSAppBarWidget({
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
      height: kToolbarHeight * 1.5,
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
              // Replace IconButton with Container to maintain space
              Container(
                width: iconSize + 16, // Icon size + padding
                height: iconSize + 16,
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
                      Icons.upload_outlined,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Get.toNamed(RouteName.uploadVideo);
                    },
                  )
                : SizedBox(width: 32,)
            ],
          ),
        ),
      ),
    );
  }
}