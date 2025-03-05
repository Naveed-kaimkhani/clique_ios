import 'dart:async';
import 'dart:convert';
import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/components/send_button.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final int memberCount;
  final String guid;
  
  final String? profileImage;
  GroupChatScreen({
    super.key,
    required this.groupName,
     this.profileImage,
    required this.memberCount,
    required this.guid,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  
final UserController userController = Get.find<UserController>();
  final StreamController<List<Map<String, dynamic>>> _messageController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Timer? _timer;
  // bool _isUploading = false;

    final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.close();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    String? token = userController.token.value;
    // String? userId = prefs.getString('user_id'); // Get logged in user ID
  String? userId= userController.uid.value.toString();
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
            "isMe": msg["sender_uid"] == userId, // Check if message is from logged in user
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
              GroupAppBar(profile: widget.profileImage, title: widget.groupName, memberCount: widget.memberCount),
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
  Future<void> _sendMessage() async {
    print("Sending message");
    // final TextEditingController _textController = TextEditingController();  
    if (_textController.text.isEmpty) return;

    // setState(() => _isUploading = true);

    final url = Uri.parse("https://dev.moutfits.com/api/v1/cometchat/groups/send-message");
    // final String token = "63|9dM3rfqqIBCkelTcgGCgoMTNQn5MRJde3glXauj956689575"; // Store and retrieve from SharedPreferences or GetStorage
        final String token =userController.token.value; // Store and retrieve from SharedPreferences or GetStorage

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "group_id": widget.guid,
        "sender_uid":widget.guid, // Retrieve the logged-in user's ID dynamically
        "message": _textController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Get.snackbar("Success", "Message sent successfully!");
      print("Message sent successfully!");
      _textController.clear();
    } else {
      Get.snackbar("Error", "Failed to send message: ${response.body}");
      print("Failed to send message: ${response.body}");
    }

    // setState(() => _isUploading = false);
  }
  Widget _chatInput(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
          SendButton(onSend: _sendMessage)
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

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:avatar_stack/positions.dart';
// import 'package:clique/components/group_appbar.dart';
// import 'package:clique/components/send_button.dart';
// import 'package:clique/constants/app_colors.dart';
// import 'package:clique/constants/app_svg_icons.dart';
// import 'package:clique/data/repositories/group_chat_api.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:avatar_stack/animated_avatar_stack.dart';

// class GroupChatScreen extends StatefulWidget {
//   final String groupName;
//   final int memberCount;
//   final String guid;

//   const GroupChatScreen({
//     super.key,
//     required this.groupName,
//     required this.memberCount,
//     required this.guid,
//   });

//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   final StreamController<List<Map<String, dynamic>>> _messageController =
//       StreamController<List<Map<String, dynamic>>>.broadcast();
//   final TextEditingController _textController = TextEditingController();
//   final GroupChatRepository _chatRepository = GroupChatRepository();
  
//   Timer? _timer;
//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }

//   void _initializeChat() {
//     _fetchMessages();
//     _startMessagePolling();
//   }

//   void _startMessagePolling() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchMessages());
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _messageController.close();
//     _textController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchMessages() async {
//     try {
//       final messages = await _chatRepository.fetchMessages(widget.guid);
//       log(messages.toString());
//       if (messages != null) {
//         _messageController.add(messages);
//       }
//     } catch (e) {
//       print('Error fetching messages: $e');
//     }
//   }

//   Future<void> _sendMessage() async {
//     if (_textController.text.isEmpty) return;

//     setState(() => _isUploading = true);

//     try {
//       final success = await _chatRepository.sendMessage(
//         widget.guid,
//         _textController.text,
//       );

//       if (success) {
//         _textController.clear();
//         await _fetchMessages();
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send message: $e');
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     await picker.pickImage(source: ImageSource.gallery);
//     // TODO: Implement image upload functionality
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GroupAppBar(
//                 title: widget.groupName, 
//                 memberCount: widget.memberCount
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//               _buildMessageList(),
//               _buildChatInput(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     return Expanded(
//       child: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _messageController.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading messages"));
//           }

//           final messages = snapshot.data ?? [];
//           return ListView.builder(
//             reverse: false,
//             itemCount: messages.length,
//             padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//             itemBuilder: (_, index) => ChatMessageWidget(message: messages[index]),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildChatInput() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: screenWidth * 0.02,
//         horizontal: screenWidth * 0.04
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildMessageTextField(),
//           ),
//           SizedBox(width: screenWidth * 0.03),
//           SendButton(onSend: _sendMessage)
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageTextField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: const Color.fromARGB(255, 214, 211, 211))
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               decoration: const InputDecoration(
//                 hintText: 'Message...',
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.only(left: 14),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.attach_file, color: AppColors.black),
//             onPressed: _pickImage,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessageWidget extends StatelessWidget {
//   final Map<String, dynamic> message;

//   const ChatMessageWidget({
//     super.key, 
//     required this.message
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMe = message['isMe'] as bool;

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: screenWidth * 0.7,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             padding: EdgeInsets.all(screenWidth * 0.03),
//             decoration: BoxDecoration(
//               gradient: isMe ? AppColors.appGradientColors : null,
//               color: isMe ? null : Colors.grey[300],
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Text(
//               message['message'],
//               style: TextStyle(
//                 color: isMe ? Colors.white : Colors.black
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

