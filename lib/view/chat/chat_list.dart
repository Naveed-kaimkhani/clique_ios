
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
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return Container(
  decoration: BoxDecoration(
    color: Colors.white,  // Background color
    borderRadius: BorderRadius.circular(10), // Rounded corners
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // Shadow color
        blurRadius: 8, // Soft blur effect
        spreadRadius: 2, // Spread of shadow
        offset: Offset(2, 4), // Position of shadow (X, Y)
      ),
    ],
  ),
  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Spacing
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside tile
    leading:CircleAvatar(
  radius: 26, // Adjust the size (default is 20)
  backgroundImage: AssetImage(chatList[index]['image']),
),

    title: Text(chatList[index]['name'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
    subtitle: Text(chatList[index]['message'],style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
    trailing: Text(chatList[index]['time']),
    onTap: () {
      Get.toNamed(RouteName.groupChatScreen);
    },
  ),
);

      },
    );
  }
}
