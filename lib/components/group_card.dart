import 'dart:convert';
import 'dart:developer';
import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:clique/data/repositories/group_repository.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class GroupCard extends StatefulWidget {
  final String backgroundImage;
  final String? profileImage;
  final String name;
  final String followers;
  final String guid;
  final int uid;
  final String groupName;
  final String authToken;
  final int memberCount;
  // final List<String> groupMemberProfiles;
  const GroupCard({       
    required this.backgroundImage,
    this.profileImage,
    required this.name,
    required this.authToken,
    required this.followers,
    // required this.groupMemberProfiles,
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
  Future<Map<String, dynamic>> fetchGroupMembers() async {
    log(widget.guid.toString());
    try {
      final response = await http.get(
        Uri.parse('https://dev.moutfits.com/api/v1/cometchat/groups/${widget.guid}/members'),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> fetchedImages = (data['data'] as List)
            .map<String>((member) => member['link'] ?? 'https://default-image-url.com') // Handle null values
            .toList();

        // Check if the current user's uid is in the members list
        final isMember = (data['data'] as List).any((member) => member['uid'] == widget.uid.toString());

        return {
          'fetchedImages': fetchedImages,
          'isMember': isMember,
        };
      } else {
        log("failed");
        throw Exception("Failed to load members");
      }
    } catch (e) {
      log("Error: $e");
      throw Exception("Error fetching members");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.75; // Responsive card width
    final double cardHeight = size.height * 0.18; // Responsive card height
    final double profileImageSize = size.width * 0.11; // Responsive profile image
    final double avatarStackWidth = size.width * 0.3; // Dynamic avatar stack width
    final double buttonWidth = size.width * 0.25; // Adjust join button width
    final double buttonHeight = size.height * 0.043; // Adjust join button height

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchGroupMembers(),
      builder: (context, snapshot) {
        final isMember = snapshot.hasData ? snapshot.data!['isMember'] : false;

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
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      widget.backgroundImage,
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
                          widget.name,
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
                              widget.followers,
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
                            // FutureBuilder for AnimatedAvatarStack
                            FutureBuilder<List<String>>(
                              future: fetchGroupMembers().then((data) => data['fetchedImages']), // Extract fetchedImages
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Show loading indicator for avatars
                                  return SizedBox(
                                    width: avatarStackWidth,
                                    height: size.height * 0.03,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else if (snapshot.hasError) {
                                  // Show error message for avatars
                                  return SizedBox(
                                    width: avatarStackWidth,
                                    height: size.height * 0.03,
                                    child: Center(child: Text("Error loading avatars")),
                                  );
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  // Show placeholder for avatars
                                  return SizedBox(
                                    width: avatarStackWidth,
                                    height: size.height * 0.03,
                                    child: Center(child: Text("No avatars")),
                                  );
                                }

                                final fetchedImages = snapshot.data!;
                                return  SizedBox(
                          width: avatarStackWidth,
                          child: AnimatedAvatarStack(
                            height: size.height * 0.03, // Responsive avatar stack height
                            avatars: [
                                 for (var n = 1; n < widget.memberCount +1; n++)
                                NetworkImage('https://i.pravatar.cc/150?img=$n'),
                                // NetworkImage("https://tinyurl.com/448x62fj"),
                              // for (var n = 0; n < 10; n++)
                              //   NetworkImage("https://tinyurl.com/448x62fj"),
                            ],
                          ),
                        );
                              },
                            ),
                            Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                color: isMember ? Colors.green : Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () async {
                                    if (isMember) {
                                      // Navigate to chat screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GroupChatScreen(
                                            profileImage: widget.profileImage,
                                            guid: widget.guid,
                                            groupName: widget.groupName,
                                            memberCount: widget.memberCount,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Join the group
                                      bool isAdded = await GroupRepository().joinGroup(widget.guid, widget.uid);
                                      if (isAdded) {
                                        // Refresh the UI or show a success message
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GroupChatScreen(
                                            profileImage: widget.profileImage,
                                            guid: widget.guid,
                                            groupName: widget.groupName,
                                            memberCount: widget.memberCount,
                                          ),
                                        ),
                                      );
                                      }
                                    }
                                  },
                                  child: Text(
                                    isMember ? "Message" : "Join Now",
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
                    image: widget.profileImage != null
                        ? DecorationImage(
                            image: NetworkImage(widget.profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: widget.profileImage == null ? Colors.grey[300] : null,
                  ),
                  child: widget.profileImage == null
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