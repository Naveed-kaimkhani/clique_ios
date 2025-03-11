
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:clique/view/chat/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:clique/view_model/discover_viewmodel.dart';

// class ChatList extends StatelessWidget {
//   final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double horizontalPadding = size.width * 0.03;
//     final double verticalPadding = size.height * 0.01;
//     final double profileImageSize = size.width * 0.11;
//     final double avatarRadius = size.width * 0.06;
//     final double fontSize = size.width * 0.04;
//     final double timeFontSize = size.width * 0.035;

//     return Obx(() {
//       if (_viewModel.isLoading.value) {
//         return Center(child: CircularProgressIndicator());
//       }

//       if (_viewModel.error.value.isNotEmpty) {
//         return Center(child: Text(_viewModel.error.value));
//       }

//       // Filter groups where user is a member (owner matches user id)
//       final userGroups = _viewModel.groups.where((group) => 
//         group.owner == _viewModel.userController.uid.value
//       ).toList();

    

//       return ListView.builder(
//         itemCount: _viewModel.groups.length,
//         itemBuilder: (context, index) {
//           final group = _viewModel.groups[index];
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(size.width * 0.025),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: size.width * 0.02,
//                   spreadRadius: size.width * 0.005,
//                   offset: Offset(size.width * 0.005, size.width * 0.01),
//                 ),
//               ],
//             ),
//             margin: EdgeInsets.symmetric(
//               horizontal: horizontalPadding,
//               vertical: verticalPadding,
//             ),
//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: horizontalPadding * 1.3,
//                 vertical: verticalPadding * 1.5,
//               ),
//               // leading: Icon(Icons.person),
//               leading:  Container(
//                   height: profileImageSize,
//                   width: profileImageSize,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: group.icon != null
//                         ? DecorationImage(
//                             image: CachedNetworkImageProvider(group.icon!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                     color:  group.icon == null ? Colors.grey[300] : null,
//                   ),
//                   child: group.icon == null
//                       ? Icon(Icons.person, size: profileImageSize * 0.6, color: Colors.grey[600])
//                       : null,
//                 ),
//               title: Text(
//                 group.name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: fontSize,
//                 ),
//               ),
//               subtitle: Text(
//                 '${group.membersCount} members',
//                 style: TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: fontSize * 0.9,
//                 ),
//               ),
//               trailing: Text(
//                 'Active',
//                 style: TextStyle(fontSize: timeFontSize),
//               ),
//               onTap: () {
//                 // Get.toNamed(RouteName.groupChatScreen, arguments: {
//                 //   'groupId': group.guid,
//                 //   'groupName': group.name
//                 // });

//                        Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => GroupChatScreen(
//                                             profileImage: group.icon,
//                                             guid: group.guid,
//                                             groupName: group.name,
//                                             memberCount: group.membersCount,
//                                           ),
//                                         ),
//                                       );
//               },
//             ),
//           );
//         },
//       );
//     });
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatelessWidget {
  final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();

  Future<List<String>> getJoinedGroups() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('joined_groups') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.03;
    final double verticalPadding = size.height * 0.01;
    final double profileImageSize = size.width * 0.11;
    final double fontSize = size.width * 0.04;
    final double timeFontSize = size.width * 0.035;

    return FutureBuilder<List<String>>(
      future: getJoinedGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading joined groups"));
        }

        final joinedGroupGUIDs = snapshot.data ?? [];

        return Obx(() {
          if (_viewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_viewModel.error.value.isNotEmpty) {
            return Center(child: Text(_viewModel.error.value));
          }

          // Filter groups where user is a member (using stored GUIDs)
          final userGroups = _viewModel.groups
              .where((group) => joinedGroupGUIDs.contains(group.guid))
              .toList();

          if (userGroups.isEmpty) {
            return Center(child: Text("No groups joined"));
          }

          return ListView.builder(
            itemCount: userGroups.length,
            itemBuilder: (context, index) {
              final group = userGroups[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.025),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: size.width * 0.02,
                      spreadRadius: size.width * 0.005,
                      offset: Offset(size.width * 0.005, size.width * 0.01),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 1.3,
                    vertical: verticalPadding * 1.5,
                  ),
                  leading: Container(
                    height: profileImageSize,
                    width: profileImageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: group.icon != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(group.icon!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: group.icon == null ? Colors.grey[300] : null,
                    ),
                    child: group.icon == null
                        ? Icon(Icons.person,
                            size: profileImageSize * 0.6, color: Colors.grey[600])
                        : null,
                  ),
                  title: Text(
                    group.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                  subtitle: Text(
                    '${group.membersCount} members',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: fontSize * 0.9,
                    ),
                  ),
                  trailing: Text(
                    'Active',
                    style: TextStyle(fontSize: timeFontSize),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          profileImage: group.icon,
                          guid: group.guid,
                          groupName: group.name,
                          memberCount: group.membersCount,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
      },
    );
  }
}
