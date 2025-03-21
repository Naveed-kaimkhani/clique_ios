


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupAppBar extends StatelessWidget {
  final String title;
  final int memberCount;
  final String? profile;
  const GroupAppBar({super.key, required this.title, required this.memberCount , this.profile});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size

    return Container(
      height: size.height * 0.11, // 12% of screen height
      width: double.infinity,
      padding: EdgeInsets.only(top: size.height * 0.03), // 4% of screen height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        // mainAxisAlignment: Mai,
        children: [
          // Back Button
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.01), // 4% of screen width
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: size.width * 0.07), // 7% of screen width
              onPressed: () {
                Get.back();
              },
            ),
          ),

          // Profile Image and Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center  ,
            children: [
              Container(
                height: size.height * 0.055, // 6% of screen height
                width: size.height * 0.055, // 6% of screen height
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: profile != null 
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(profile!),
                        fit: BoxFit.cover,
                      )
                    : null,
                  color: profile == null ? Colors.grey[300] : null,
                ),
                child: profile == null 
                  ? Icon(Icons.person, size: size.height * 0.033, color: Colors.grey[600])
                  : null,
              ),
              SizedBox(width: size.width * 0.02), // 2% of screen width
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045, // 4.5% of screen width
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      memberCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.04, // 4% of screen width
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Info Icon
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: size.width * 0.04), // 4% of screen width
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: size.width * 0.07, // 7% of screen width
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}