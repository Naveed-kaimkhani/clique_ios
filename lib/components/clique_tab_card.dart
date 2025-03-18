import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class CliqueTabCard extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;
  final String name;
  final String followers;
  final String guid;
  final int uid;
  final String authToken;
  final int memberCount;
  final bool isJoined;
  const CliqueTabCard({
    required this.backgroundImage,
    required this.profileImage,
    required this.name,
    required this.followers,
    required this.isJoined,
    required this.guid,
    required this.uid,
    required this.authToken,
    required this.memberCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.75;
    final double cardHeight = size.height * 0.26;
    final double profileImageSize = size.width * 0.12;
    final double avatarStackWidth = size.width * 0.3;
    final double buttonWidth = size.width * 0.25;
    final double buttonHeight = size.height * 0.04;

    return FutureBuilder<Map<String, dynamic>>(
      future: GroupRepository.fetchGroupMembers(authToken, guid, uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(padding: EdgeInsets.all(8),
          child: ShimmerEffect(
            cardHeight: cardHeight,
            cardWidth: cardWidth,
            buttonHeight: buttonHeight,
            buttonWidth: buttonWidth,
            size: size,
            avatarStackWidth: avatarStackWidth,
          ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading group members"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("No data available"));
        }

        final fetchedImages = snapshot.data!['fetchedImages'] as List<String>;
        final isMember = snapshot.data!['isMember'] as bool;

        return Container(
          width: cardWidth,
          height: cardHeight,
          padding: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03),
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
                      height: cardHeight * 0.3,
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
                            fontSize: size.width * 0.045,
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
                                height: size.height * 0.03,
                                avatars: [
                                  for (var n = 1; n < memberCount + 1; n++)
                                    CachedNetworkImageProvider('https://i.pravatar.cc/150?img=$n'),
                                ],
                              ),
                            ),
                            Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                gradient: isJoined ? AppColors.appGradientColors : AppColors.backGradientColors,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () async {
                                    if (isJoined) {
                                      Get.toNamed(RouteName.groupChatScreen);
                                    } else {
                                      // bool isAdded = await GroupRepository().joinGroup(guid, uid);
                                      if (isJoined) {
                                        // await Utils.saveJoinedGroup(guid);
                                        Get.toNamed(RouteName.groupChatScreen);
                                      }
                                    }
                                  },
                                  child: Text(
                                    isMember ? "Message" : "Join Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.036,
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
                child: Container(
                  height: profileImageSize,
                  width: profileImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: profileImage.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(profileImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: profileImage.isEmpty ? Colors.grey[300] : null,
                  ),
                  child: profileImage.isEmpty
                      ? Icon(Icons.person, size: profileImageSize * 0.6, color: Colors.grey[600])
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }



}


  class ShimmerEffect extends StatelessWidget {
    final double cardWidth;
    final double cardHeight;
    final double avatarStackWidth;
    final double buttonWidth;
    final double buttonHeight;
    final Size size;

    const ShimmerEffect({
      required this.cardWidth,
      required this.cardHeight,
      required this.avatarStackWidth,
      required this.buttonWidth,
      required this.buttonHeight,
      required this.size,
      super.key,
    });
  
    @override
    Widget build(BuildContext context) {
      return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03, bottom:size.width * 0.03 ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(31, 184, 177, 177),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    height: cardHeight * 0.3,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: size.width * 0.4,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: avatarStackWidth,
                              height: 30,
                              color: Colors.white,
                            ),
                            Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
    }
  }