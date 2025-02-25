
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> chatList = [
    {
      'name': 'Fashion knowledge 2024',
      'message': 'Hey, how is it going today',
      'time': '04:50 PM',
      'image': AppSvgIcons.profile,
      'isUnread': true
    },
    {
      'name': 'Beautyproducts',
      'message': 'Hey, how is it going today',
      'time': '04:50 PM',
      'image': AppSvgIcons.profile,
      'isUnread': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.03;
    final double verticalPadding = size.height * 0.01;
    final double avatarRadius = size.width * 0.06;
    final double fontSize = size.width * 0.04;
    final double timeFontSize = size.width * 0.035;

    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
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
            leading: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(chatList[index]['image']),
            ),
            title: Text(
              chatList[index]['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            subtitle: Text(
              chatList[index]['message'],
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontSize * 0.9,
              ),
            ),
            trailing: Text(
              chatList[index]['time'],
              style: TextStyle(fontSize: timeFontSize),
            ),
            onTap: () {
              Get.toNamed(RouteName.groupChatScreen);
            },
          ),
        );
      },
    );
  }
}
