import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clique/view_model/discover_viewmodel.dart';

class ChatList extends StatelessWidget {
  final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.03;
    final double verticalPadding = size.height * 0.01;
    final double avatarRadius = size.width * 0.06;
    final double fontSize = size.width * 0.04;
    final double timeFontSize = size.width * 0.035;

    return Obx(() {
      if (_viewModel.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (_viewModel.error.value.isNotEmpty) {
        return Center(child: Text(_viewModel.error.value));
      }

      // Filter groups where user is a member (owner matches user id)
      final userGroups = _viewModel.groups.where((group) => 
        group.owner == _viewModel.userController.uid.value
      ).toList();

      if (userGroups.isEmpty) {
        return Center(child: Text('You haven\'t joined any groups yet'));
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
              leading: Icon(Icons.person),
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
                Get.toNamed(RouteName.groupChatScreen, arguments: {
                  'groupId': group.guid,
                  'groupName': group.name
                });
              },
            ),
          );
        },
      );
    });
  }
}
