// import 'package:avatar_stack/positions.dart';
// import 'package:clique/components/group_appbar.dart';
// import 'package:clique/components/send_button.dart';
// import 'package:clique/constants/app_colors.dart';
// import 'package:clique/constants/app_svg_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:avatar_stack/animated_avatar_stack.dart';

// class GroupChatScreen extends StatelessWidget {
//   final String groupName;
//   final int memberCount;

//   GroupChatScreen({
//     super.key,
//     required this.groupName,
//     required this.memberCount,
//   });

//   bool _isUploading = false;

//   final List<Map<String, dynamic>> messages = [
//     {
//       'sender': 'Ethan Kingsley',
//       'message': "Don't forget today is a holiday so let's post something that celebrates it!",
//       'time': '6:24 PM',
//       'isMe': false,
//       'seenBy': [AppSvgIcons.profile,AppSvgIcons.profile],
//     },
//     {
//       'sender': 'Jennifer',
//       'message': "I'll get a post out in the next 30 minutes promoting our drink of the day...",
//       'time': '6:27 PM',
//       'isMe': true,
//       'seenBy': [AppSvgIcons.profile, AppSvgIcons.profile, AppSvgIcons.profile],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       color: Colors.black,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GroupAppBar(title: groupName, memberCount: memberCount),
//               SizedBox(height: screenHeight * 0.01),

//               // Chat Messages List
//               Expanded(
//                 child: ListView.builder(
//                   reverse: false,
//                   itemCount: messages.length,
//                   padding: EdgeInsets.all(screenWidth * 0.03),
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     return ChatMessageWidget(message: message);
//                   },
//                 ),
//               ),

//               if (_isUploading)
//                 const Padding(
//                   padding: EdgeInsets.all(8),
//                   child: CircularProgressIndicator(),
//                 ),

//               // Chat Input Field
//               _chatInput(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _chatInput(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     final TextEditingController _textController = TextEditingController();
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: screenWidth * 0.02,
//         horizontal: screenWidth * 0.04),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: const Color.fromARGB(255, 214, 211, 211))  
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       decoration: const InputDecoration(
//                         hintText: 'Message...',
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(left: 14),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.attach_file, color: AppColors.black),
//                     onPressed: () async {
//                       final ImagePicker picker = ImagePicker();
//                       await picker.pickImage(source: ImageSource.gallery);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: screenWidth * 0.03),
//           SendButton()
//         ],
//       ),
//     );
//   }
// }

// class ChatMessageWidget extends StatelessWidget {
//   final Map<String, dynamic> message;

//   const ChatMessageWidget({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final settings = RestrictedPositions(
//       maxCoverage: -0.1,
//       minCoverage: -0.5,
//       align: StackAlign.right,
//       layoutDirection: LayoutDirection.horizontal
//     );
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Align(
//       alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           // Chat Bubble
//           Container(
//             width: screenWidth * 0.7,
//             margin: EdgeInsets.symmetric(vertical: 10),
//             padding: EdgeInsets.all(screenWidth * 0.03),
//             decoration: BoxDecoration(
//               gradient: message['isMe']
//                   ? AppColors.appGradientColors
//                   : LinearGradient(colors: [Colors.white, Colors.white]),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (!message['isMe'])
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 5),
//                     child: Text(
//                       message['sender'],
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 Text(
//                   message['message'],
//                   style: TextStyle(color:message['isMe'] ? Colors.white: Colors.black),
//                 ),
           
//                 SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       message['time'],
//                       style: TextStyle(fontSize: screenWidth * 0.03, color:message['isMe'] ? Colors.white: Colors.black),
//                     ),
//                   ],
//                 ),
//                 if (message['isMe'] && message['seenBy'] != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5, right: 5),
//                     child: SizedBox(
//                       width: 80,
//                       child: AnimatedAvatarStack(
//                         height: 24,
//                         avatars: [
//                           for (var n = 0; n < 5; n++) 
//                             NetworkImage('https://i.pravatar.cc/150?img=$n'),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:avatar_stack/positions.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/components/send_button.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final int memberCount;
  final String guid;
  GroupChatScreen({
    super.key,
    required this.groupName,
    required this.memberCount,
    required this.guid,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final StreamController<List<Map<String, dynamic>>> _messageController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _fetchMessages());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.close();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String url = "https://dev.moutfits.com/api/v1/cometchat/groups/${widget.guid}/messages";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<Map<String, dynamic>> messages = responseData.map((msg) {
          return {
            "sender": msg["name"],
            "message": msg["message"],
            "isMe": msg["uid"] == "app_system" ? false : true,
            "time": "Now",
            "seenBy": [AppSvgIcons.profile],
          };
        }).toList();

        _messageController.add(messages);
      } else {
        print("Failed to load messages: ${response.body}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

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
              GroupAppBar(title: widget.groupName, memberCount: widget.memberCount),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _messageController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error loading messages"));
                    }

                    final messages = snapshot.data ?? [];

                    return ListView.builder(
                      reverse: false,
                      itemCount: messages.length,
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      itemBuilder: (context, index) {
                        return ChatMessageWidget(message: messages[index]);
                      },
                    );
                  },
                ),
              ),
              _chatInput(context),
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
          vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color.fromARGB(255, 214, 211, 211))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: AppColors.black),
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.7,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: message['isMe']
                  ? AppColors.appGradientColors
                  : LinearGradient(colors: [const Color.fromARGB(255, 240, 240, 240), const Color.fromARGB(255, 235, 235, 235)]),
              borderRadius: BorderRadius.circular(15),
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
                  style: TextStyle(color: message['isMe'] ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
