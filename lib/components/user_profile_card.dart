
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final bool isInfluencer;
  const UserProfileCard({super.key, required this.isInfluencer});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9, // 90% of screen width
      height: 282,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppSvgIcons.profile,
            height: screenWidth * 0.35, // 45% of screen width
            width: screenWidth * 0.35,
              fit: BoxFit.cover, // Ensures it fills the given size

          ),
          SizedBox(height: 10,),
          Text(
            'Brian Brunner',
            style: TextStyle(
              fontSize: screenWidth * 0.08, // 8% of screen width
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@brianbrunner',
            style: TextStyle(
              fontSize: screenWidth * 0.05, // 5% of screen width
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
