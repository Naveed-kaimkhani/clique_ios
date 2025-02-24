

import 'package:avatar_stack/positions.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/components/send_button.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avatar_stack/animated_avatar_stack.dart';

class GroupChatScreen extends StatelessWidget {
  GroupChatScreen({super.key});

  bool _isUploading = false;

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'Ethan Kingsley',
      'message': "Don't forget today is a holiday so let's post something that celebrates it!",
      'time': '6:24 PM',
      'isMe': false,
      'seenBy': [AppSvgIcons.profile,AppSvgIcons.profile],
    },
    {
      'sender': 'Jennifer',
      'message': "I’ll get a post out in the next 30 minutes promoting our drink of the day...",
      'time': '6:27 PM',
      'isMe': true,
      'seenBy': [AppSvgIcons.profile, AppSvgIcons.profile, AppSvgIcons.profile],
    },

  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
          color: Colors.black,
      child: SafeArea(
        
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  GroupAppBar(title: "Group 1"),
                  SizedBox(height: screenHeight * 0.01),
      
                  // Chat Messages List
                  Expanded(
                    child: ListView.builder(
                      reverse: false,
                      itemCount: messages.length,
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatMessageWidget(message: message);
                      },
                    ),
                  ),
      
                  if (_isUploading)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
        // if (messages.last['isMe'] && messages.last['seenBy'] != null)
        //                 Padding(
        //                   padding: EdgeInsets.only(top: screenHeight * 0.02),
        //                   child: AnimatedAvatarStack(
        //                     height: 24,
        //                     avatars: [
        //                       for (var n = 0; n < 3; n++) 
        //                         NetworkImage('https://i.pravatar.cc/150?img=$n'),
        //                     ],
        //                   ),
        //                 ),
                  // Chat Input Field
                  _chatInput(context),
      
                  // "Seen By" avatars at the end of all messages
                
                ],
              ),
        ),
      ),
    );
  }

  Widget _chatInput(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController _textController = TextEditingController();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color.fromARGB(255, 214, 211, 211))  
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 14), // Adds left padding to cursor

                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: AppColors.black),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      await picker.pickImage(source: ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          SendButton()
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
      final settings = RestrictedPositions(
      maxCoverage: -0.1,
      minCoverage: -0.5,
      align: StackAlign.right,
      layoutDirection: LayoutDirection.horizontal
    );
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat Bubble
          Container(
            width: screenWidth * 0.7,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: message['isMe']
                  ? AppColors.appGradientColors
                  : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!message['isMe'])
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      message['sender'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                Text(
                  message['message'],
                  style: TextStyle(color:message['isMe'] ? Colors.white: Colors.black),
                ),
           
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message['time'],
                      style: TextStyle(fontSize: screenWidth * 0.03, color:message['isMe'] ? Colors.white: Colors.black),
                    ),
                  ],
                ),
                if (message['isMe'] && message['seenBy'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 5),
                    child: SizedBox(
                      width: 80,
                      child: AnimatedAvatarStack(
                        // settings: settings,
                        height: 24,
                        avatars: [
                          for (var n = 0; n < 5; n++) 
                            NetworkImage('https://i.pravatar.cc/150?img=$n'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}