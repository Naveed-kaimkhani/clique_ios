

import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String backgroundImage;
  final String? profileImage;
  final String name;
  final String followers;
  final String guid;
  final int uid;
  final String groupName;
  final int memberCount;
  const GroupCard({       
    required this.backgroundImage,
    this.profileImage,
    required this.name,
    required this.followers,
    required this.guid,
    required this.uid,
    required this.groupName,
    required this.memberCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.75; // Responsive card width
    final double cardHeight = size.height * 0.18; // Responsive card height
    final double profileImageSize = size.width * 0.11; // Responsive profile image
    final double avatarStackWidth = size.width * 0.3; // Dynamic avatar stack width
    final double buttonWidth = size.width * 0.25; // Adjust join button width
    final double buttonHeight = size.height * 0.043; // Adjust join button height

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(left: size.width * 0.03, ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(31, 184, 177, 177),
        //     blurRadius: 10,
        //     spreadRadius: 0.5,
        //   ),
        // ],
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
                              onPressed: ()async {
                              bool isAdded= await GroupRepository().joinGroup(guid, uid);
                              isAdded   ? Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChatScreen(profileImage: profileImage , guid: guid , groupName: groupName, memberCount: memberCount,))):null;
    
                              },
                              child: Text(
                                "Join Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.032, // Responsive font size
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
            top: cardHeight * 0.16,
            left: size.width * 0.03,
            child: Container(
              height: profileImageSize,
              width: profileImageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: profileImage != null 
                  ? DecorationImage(
                      image: NetworkImage(profileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
                color: profileImage == null ? Colors.grey[300] : null,
              ),
              child: profileImage == null 
                ? Icon(Icons.person, size: profileImageSize * 0.6, color: Colors.grey[600])
                : null,
            ),
          ),
        ],
      ),
    );
  }
}
