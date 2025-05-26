

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/data/models/influencer_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view_model/follow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfluencerCard extends StatelessWidget {
  final String? backgroundImage;
  final String? profileImage;
  final String name;
  final String followers;
  final int id;
  final RxBool isFollowing; // ✅ Convert bool to RxBool
  final InfluencerModel influencerModel;
  final FollowController followController = Get.put(FollowController());

  InfluencerCard({
    required this.id,
    required this.backgroundImage,
    required this.profileImage,
    required this.name,
    required this.influencerModel,
    required this.followers,
    required bool isFollowing, // ✅ Accept bool
    super.key,
  }) : isFollowing = isFollowing.obs; // ✅ Convert to RxBool

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
                child:backgroundImage!=null?  CachedNetworkImage(
                  imageUrl: backgroundImage ?? '',
                  height: cardHeight * 0.3, // Responsive image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
  height: cardHeight * 0.3,
  width: double.infinity,
  color: Colors.grey[300], // Light grey background
),

                  errorWidget: (context, url, error) => Container(
  height: cardHeight * 0.3,
  width: double.infinity,
  color: Colors.grey[300], // Light grey background
),

                ):Container(
  height: cardHeight * 0.3,
  width: double.infinity,
  color: Colors.grey[300], // Light grey background
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
            
Obx(() => Container(
  height: cardHeight * 0.15,
  width: double.infinity,
  decoration: BoxDecoration(
    gradient: AppColors.appGradientColors,
    borderRadius: BorderRadius.circular(30),
  ),
  child: TextButton(
    onPressed: () async {
      bool previousStatus = isFollowing.value;
      isFollowing.value = !isFollowing.value;

      bool success = isFollowing.value
          ? await followController.toggleFollow(id)
          : await followController.toggleUnFollow(id);

      if (!success) {
        isFollowing.value = previousStatus;
      }
    },
    child: Text(
      isFollowing.value ? "Unfollow" : "+ Follow",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: size.width * 0.028,
      ),
    ),
  ),
))

                  ],
                ),
              ),
            ],
          ),
       Positioned(
            top: cardHeight * 0.14,
            left: size.width * 0.02,
            child: GestureDetector(
              onTap: () => Get.toNamed(RouteName.influencerProfile, arguments: influencerModel),
              child: ClipOval(
                child: profileImage!=null? CachedNetworkImage(
                  imageUrl: profileImage??"",
                  width: profileImageSize,
                  height: profileImageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: profileImageSize,
                    height: profileImageSize,
                    color: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.white70, size: profileImageSize),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: profileImageSize,
                    height: profileImageSize,
                    color: Colors.grey[300],
                    child:  Icon(Icons.person, color: Colors.white70, size: profileImageSize),
                  ),
                ):Container(
                    width: profileImageSize,
                    height: profileImageSize,
                    color: Colors.grey[300],
                    child:  Icon(Icons.person, color: Colors.white70, size: profileImageSize),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


