import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserProfileCard extends StatelessWidget {
  final bool isInfluencer;
  final String username;
  
  final String? profileImage;
  const UserProfileCard({super.key, required this.isInfluencer, required this.username,required this.profileImage,});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.35, // Responsive height based on screen height
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(size.width * 0.05), // Responsive border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: size.width * 0.012, // Responsive blur
            spreadRadius: size.width * 0.002, // Responsive spread
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   AppSvgIcons.profile,
          //   height: screenHeight * 0.18, // Responsive height
          //   width: screenHeight * 0.18, // Keep aspect ratio square
          //   fit: BoxFit.cover,
          // ),
          profileImage==null
                            // ? Icon(Icons.person, size:MediaQuery.of(context).size.width * 0.3 ,)
                                                       ?  Image.asset(
        AppSvgIcons.profile,
              width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
                  height: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover
      )

                            : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profileImage??'',
                  width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
                  height: MediaQuery.of(context).size.width * 0.3, // Set the height
                  fit: BoxFit.cover, // Ensure the image covers the circular area
                  placeholder: (context, url) => SpinKitChasingDots(color: Colors.white, size: 20),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
          SizedBox(height: screenHeight * 0.015), // Responsive spacing
          Text(
            username,
            style: TextStyle(
              fontSize: screenHeight * 0.035, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.005), // Responsive spacing
          // Text(
          //   '@brianbrunner',
          //   style: TextStyle(
          //     fontSize: screenHeight * 0.02, // Responsive font size
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }
}
