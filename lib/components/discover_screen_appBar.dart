import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// class DiscoverScreenAppBar extends PreferredSize {
//   final String title;
//   final IconData? icon;
//   final bool isNotification;

//   final IconData? logoutIcon;
//   DiscoverScreenAppBar({
//     super.key,
//     required this.title,
//     this.logoutIcon,
//     this.icon,
//     this.isNotification = false,
//   }) : super(
//           preferredSize:
//               const Size.fromHeight(kToolbarHeight * 0.8), // Increased height
//           child: _DiscoverScreenAppBarWidget(
//             title: title,
//             icon: icon,
//             isNotification: isNotification,
//           ),
//         );
// }

// class _DiscoverScreenAppBarWidget extends StatelessWidget {
//   final String title;
//   final IconData? icon;
//   final bool isNotification;

//   _DiscoverScreenAppBarWidget({
//     required this.title,
//     this.icon,
//     this.isNotification = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final iconSize = screenWidth * 0.07;
//     final titleFontSize = screenWidth * 0.06;
//     final horizontalPadding = screenWidth * 0.04;

//     return Container(
//       height: kToolbarHeight * 1.7, // Increased height
//       decoration: BoxDecoration(
//         gradient: AppColors.appGradientColors,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(22),
//           bottomRight: Radius.circular(22),
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//           child: Row(
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: titleFontSize,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'SofiaPro'),
//               ),
//               IconButton(
//                   onPressed: () => Get.toNamed(RouteName.cartScreen),
//                   icon: Icon(Icons.card_travel))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
          preferredSize:
              const Size.fromHeight(kToolbarHeight * 0.8), // Increased height
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.07;
    final titleFontSize = screenWidth * 0.06;
    final horizontalPadding = screenWidth * 0.04;

    return Container(
      height: kToolbarHeight * 1.7, // Increased height
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Aligning title and icon
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center, // Centering the title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SofiaPro',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(RouteName.cartScreen),
                icon: Icon(Icons.card_travel),
                iconSize: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
