

import 'package:clique/constants/index.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscoverScreenAppBar extends PreferredSize {
  final String title;
  final IconData? icon;
  final bool isNotification;
  final IconData? logoutIcon;

  DiscoverScreenAppBar({
    super.key,
    required this.title,
    this.logoutIcon,
    this.icon,
    this.isNotification = false,
  }) : super(
          preferredSize: const Size.fromHeight(kToolbarHeight * 1.9),
          child: _DiscoverScreenAppBarWidget(
            title: title,
            icon: icon,
            isNotification: isNotification,
          ),
        );
}

class _DiscoverScreenAppBarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isNotification;

  _DiscoverScreenAppBarWidget({
    required this.title,
    this.icon,
    this.isNotification = false,
  });

  final CartQuantityController cartQuantityController =
      Get.put(CartQuantityController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.07;
    final titleFontSize = screenWidth * 0.06;
    final horizontalPadding = screenWidth * 0.04;

    return Container(
      height: kToolbarHeight * 1.9,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Title in the center
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SofiaPro',
                  ),
                ),
              ),

              // Shopping Cart icon on the right
              Positioned(
                right: 0,
                child: Obx(() {
                  int totalItems = cartQuantityController.totalItems;
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed(RouteName.cartScreen),
                        icon: const Icon(Icons.shopping_cart),
                        iconSize: iconSize,
                        color: Colors.white,
                      ),
                      if (totalItems > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$totalItems',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
