import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/controller/group_controler.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupCard extends StatefulWidget {
  final String backgroundImage;
  final String? profileImage;
  final String name;
  final String followers;
  final bool isJoin;
  final String guid;
  final int uid;
  final String groupName;
  final String authToken;
  final int memberCount;

  const GroupCard({
    required this.backgroundImage,
    required this.isJoin,
    this.profileImage,
    required this.name,
    required this.authToken,
    required this.followers,
    required this.guid,
    required this.uid,
    required this.groupName,
    required this.memberCount,
    super.key,
  });

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  final GroupController groupController = Get.put(GroupController());
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.75;
    final double cardHeight = size.height * 0.18;
    final double profileImageSize = size.width * 0.11;
    final double avatarStackWidth = size.width * 0.3;
    final double buttonWidth = size.width * 0.25;
    final double buttonHeight = size.height * 0.043;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(left: size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Background image (placeholder color used here)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(
                  height: cardHeight * 0.3,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),

              // Group content section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.02,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.015),
                    Text(
                      widget.name,
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
                        Icon(Icons.group,
                            size: size.width * 0.04, color: Colors.grey),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          widget.followers,
                          style: TextStyle(
                              fontSize: size.width * 0.035, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar stack for group members
                        SizedBox(
                          width: avatarStackWidth,
                          child: AnimatedAvatarStack(
                            height: size.height * 0.03,
                            avatars: [
                              for (var n = 1; n < widget.memberCount + 1; n++)
                                NetworkImage(
                                    'https://i.pravatar.cc/150?img=$n'),
                            ],
                          ),
                        ),
                        Container(
                          width: buttonWidth,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            gradient: widget.isJoin
                                ? AppColors.appGradientColors
                                : AppColors.backGradientColors,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: TextButton(
                                onPressed: () async {
                                  if (widget.isJoin) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GroupChatScreen(
                                          profileImage: widget.profileImage,
                                          uid: userController.uid.value,
                                          guid: widget.guid,
                                          groupName: widget.groupName,
                                          memberCount: widget.memberCount,
                                        ),
                                      ),
                                    );
                                  } else {
                                    groupController.isJoining.value = true;

                                    await groupController.joinGroup(
                                        widget.guid, widget.uid);

                                    groupController.isJoining.value = false;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GroupChatScreen(
                                          profileImage: widget.profileImage,
                                          uid: userController.uid.value,
                                          guid: widget.guid,
                                          groupName: widget.groupName,
                                          memberCount: widget.memberCount,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: widget.isJoin
                                    ? Text(
                                        widget.isJoin ? "Message" : "Join now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.032,
                                        ),
                                      )
                                    : Obx(() {
                                        return Text(
                                          groupController.isJoining.value
                                              ? "Joining..."
                                              : "Join now",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.032,
                                          ),
                                        );
                                      })),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Profile image
          Positioned(
            top: cardHeight * 0.16,
            left: size.width * 0.03,
            child: Container(
              height: profileImageSize,
              width: profileImageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: widget.profileImage != null
                    ? DecorationImage(
                        image: NetworkImage(widget.profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: widget.profileImage == null ? Colors.grey[300] : null,
              ),
              child: widget.profileImage == null
                  ? Icon(Icons.person,
                      size: profileImageSize * 0.6, color: Colors.grey[600])
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// Join Button Text with reactive UI
class JoinButtonText extends StatelessWidget {
  final bool isJoin;

  const JoinButtonText({super.key, required this.isJoin});

  @override
  Widget build(BuildContext context) {
    final groupController = Get.find<GroupController>();
    return Obx(() {
      return Text(
        isJoin
            ? "Message"
            : groupController.isJoining.value
                ? "Joining..."
                : "Join Now",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.032,
        ),
      );
    });
  }
}
