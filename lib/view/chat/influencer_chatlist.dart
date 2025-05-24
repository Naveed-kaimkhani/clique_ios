

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/data/models/group_model.dart';
import 'package:clique/view/chat/chat_screen.dart';
import 'package:clique/view_model/group_view_model.dart';
import 'package:clique/view_model/influencer_joined_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfluencerChatList extends StatelessWidget {
  
 final int influencerId;
  InfluencerChatList({super.key, required this.influencerId});
  final InfluencerJoinedGroup _viewModel = Get.isRegistered<InfluencerJoinedGroup>()
    ? Get.find<InfluencerJoinedGroup>()
    : Get.put(InfluencerJoinedGroup());


@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: _viewModel.fetchGroups(influencerId), // Explicitly trigger data fetch
    builder: (context, snapshot) {
      return Obx(() {
        if (_viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        if (_viewModel.error.value.isNotEmpty) {
          return Center(child: Text(_viewModel.error.value));
        }

        final userGroups = _viewModel.groups.where((group) => group.isJoined).toList();

        if (userGroups.isEmpty) {
          return Center(child: Text("No groups joined"));
        }

        return ListView.builder(
          itemCount: userGroups.length,
          itemBuilder: (context, index) {
            final group = userGroups[index];
            return _buildGroupTile(context, group);
          },
        );
      });
    },
  );
}
Widget _buildGroupTile(BuildContext context, Group group) {
  final size = MediaQuery.of(context).size;
  final double profileImageSize = size.width * 0.11;
  final double fontSize = size.width * 0.04;
  final double horizontalPadding = size.width * 0.03;
  final double verticalPadding = size.height * 0.01;

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
        vertical: verticalPadding * 0.8,
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
            ? Icon(Icons.person, size: profileImageSize * 0.6, color: Colors.grey[600])
            : null,
      ),
      title: Text(
        group.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
      subtitle: Text(
        '${group.membersCount} members',
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize * 0.9),
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => GroupChatScreen(
        //       profileImage: group.icon,
        //       guid: group.guid,
        //       groupName: group.name,
        //       memberCount: group.membersCount,
        //     ),
        //   ),
        // );
      },
    ),
  );
}

}
