


import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupAppBar extends StatelessWidget {
  final String title;
  final int memberCount;
  const GroupAppBar({super.key, required this.title, required this.memberCount});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size

    return Container(
      height: size.height * 0.11, // 12% of screen height
      width: double.infinity,
      padding: EdgeInsets.only(top: size.height * 0.02), // 4% of screen height
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
              Image.asset(
                AppSvgIcons.profile,
                height: size.height * 0.055, // 6% of screen height
                width: size.height * 0.055, // 6% of screen height
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