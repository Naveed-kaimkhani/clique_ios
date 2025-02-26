import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CliqueTabCard extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;
  final String name;
  final String followers;

  const CliqueTabCard({
    required this.backgroundImage,
    required this.profileImage,
    required this.name,
    required this.followers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.75; // Responsive card width
    final double cardHeight = size.height * 0.28; // Responsive card height
    final double profileImageSize = size.width * 0.12; // Responsive profile image
    final double avatarStackWidth = size.width * 0.3; // Dynamic avatar stack width
    final double buttonWidth = size.width * 0.25; // Adjust join button width
    final double buttonHeight = size.height * 0.04; // Adjust join button height

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(left: size.width * 0.03,right: size.width * 0.03),
      decoration: BoxDecoration(
               boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(31, 184, 177, 177),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
        borderRadius: BorderRadius.circular(15),
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
                  height: cardHeight * 0.3, // Responsive background image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.015),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: size.width * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.005),
                    Row(
                      children: [
                        Icon(Icons.group, size: size.width * 0.04, color: Colors.grey),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          followers,
                          style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: avatarStackWidth,
                          child: AnimatedAvatarStack(
                            height: size.height * 0.03, // Responsive avatar stack height
                            avatars: [
                              for (var n = 0; n < 10; n++)
                                NetworkImage('https://i.pravatar.cc/150?img=$n'),
                            ],
                          ),
                        ),
                        Container(
                          width: buttonWidth,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(RouteName.groupChatScreen);
                              },
                              child: Text(
                                "Join Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.036, // Responsive font size
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: cardHeight * 0.22,
            left: size.width * 0.03,
            child: Image.asset(
              AppSvgIcons.profile,
              height: profileImageSize,
              width: profileImageSize,
            ),
          ),
        ],
      ),
    );
  }
}
