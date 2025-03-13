import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfluencerCard extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;
  final String name;
  final String followers;

  const InfluencerCard({
    required this.backgroundImage,
    required this.profileImage,
    required this.name,
    required this.followers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.35; // Adjust width based on screen size
    final double cardHeight = size.height * 0.26; // Adjust height dynamically
    final double profileImageSize = size.width * 0.12; // Responsive profile image size

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(left: size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
            boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(31, 184, 177, 177),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  backgroundImage,
                  height: cardHeight * 0.3, // Responsive image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: cardHeight * 0.02),
                    Text(
                      name,
                      style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: cardHeight * 0.01),
                    Text(
                      followers,
                      style: TextStyle(fontSize: size.width * 0.033, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: cardHeight * 0.04),
                    Container(
                      height: cardHeight * 0.14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.appGradientColors,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "+ Follow",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.028,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: cardHeight * 0.14, // Responsive position for profile image
            left: size.width * 0.02,
            child: GestureDetector(
              onTap: () => Get.toNamed(RouteName.influencerProfile),
              child: Image.asset(
                AppSvgIcons.profile,
                height: profileImageSize,
                width: profileImageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
