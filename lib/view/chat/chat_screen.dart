
// // // views/group_chat_screen.dart


import 'dart:developer';

import 'package:clique/components/chat_input.dart';
import 'package:clique/components/chat_message.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/models/message_model.dart';
import 'package:clique/view_model/group_chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';
// // class GroupChatScreen extends StatelessWidget {
// //   final String groupName;
// //   final int memberCount;
// //   final String guid;
// //   final String? profileImage;

// //   GroupChatScreen({
// //     super.key,
// //     required this.groupName,
// //     this.profileImage,
// //     required this.memberCount,
// //     required this.guid,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final UserController userController = Get.find<UserController>();
// //     final GroupChatViewModel viewModel = Get.put(GroupChatViewModel(
// //       groupId: guid,
// //       token: userController.token.value,
// //       userId: userController.uid.value.toString(),
// //     ));

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           GroupAppBar(
// //             profile: profileImage,
// //             title: groupName,
// //             memberCount: memberCount,
// //           ),
// //           Expanded(
// //             child: StreamBuilder<List<MessageModel>>(
// //               stream: viewModel.messagesStream,
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(child: CircularProgressIndicator());
// //                 }

// //                 if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return Center(child: Text("No messages found"));
// //                 }

// //                 final messages = snapshot.data!;
// //                 return ListView.builder(
// //                   padding: EdgeInsets.all(16),
// //                   itemCount: messages.length,
// //                   itemBuilder: (context, index) {
// //                     return ChatMessageWidget(message: messages[index]);
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           ChatInputWidget(onSend: viewModel.sendMessage),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // views/group_chat_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class GroupChatScreen extends StatefulWidget {
//   final String groupName;
//   final int memberCount;
//   final String guid;
//   final String? profileImage;

//   GroupChatScreen({
//     super.key,
//     required this.groupName,
//     this.profileImage,
//     required this.memberCount,
//     required this.guid,
//   });

//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   late GroupChatViewModel viewModel;

//   @override
//   void initState() {
//     super.initState();
//     final UserController userController = Get.find<UserController>();
//     viewModel = Get.put(GroupChatViewModel(
//       groupId: widget.guid,
//       token: userController.token.value,
//       userId: userController.uid.value.toString(),
//     ));

//     // Add a listener to detect when the user scrolls to the top
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
//         viewModel.loadMoreMessages();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("group idd isss");
//     log(widget.guid);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GroupAppBar(
//             profile: widget.profileImage,
//             title: widget.groupName,
//             memberCount: widget.memberCount,
//           ),
//           Expanded(
//             child: StreamBuilder<List<MessageModel>>(
//               stream: viewModel.messagesStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text("No messages found"));
//                 }

//                 final messages = snapshot.data!;
//                 return ListView.builder(
//                   controller: _scrollController,
//                   reverse: true, // Set to true to show latest messages at the bottom
//                   padding: EdgeInsets.all(16),
//                   itemCount: messages.length + 1, // +1 for the loading indicator
//                   itemBuilder: (context, index) {
//                     if (index == messages.length) {
//                       // Show a loading indicator at the top of the list
//                       return Center(
//                         child: viewModel.hasMoreMessages
//                             ? CircularProgressIndicator()
//                             : SizedBox.shrink(),
//                       );
//                     }
//                     return ChatMessageWidget(message: messages[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//           ChatInputWidget(
//             onSend: (message) {
//               viewModel.sendMessage(message);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// views/group_chat_screen.dart
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
  final ScrollController _scrollController = ScrollController();
  late GroupChatViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final UserController userController = Get.find<UserController>();

    // Create a new instance of GroupChatViewModel for this screen
    viewModel = Get.put(GroupChatViewModel(
      groupId: widget.guid,
      token: userController.token.value,
      userId: userController.uid.value.toString(),
    ));

    // Add a listener to detect when the user scrolls to the top
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
        viewModel.loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Dispose of the ViewModel when the screen is closed
    Get.delete<GroupChatViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupAppBar(
            profile: widget.profileImage,
            title: widget.groupName,
            memberCount: widget.memberCount,
          ),
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: viewModel.messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No messages found"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: false, // Set to true to show latest messages at the bottom
                  padding: EdgeInsets.all(16),
                  itemCount: messages.length + 1, // +1 for the loading indicator
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      // Show a loading indicator at the top of the list
                      return Center(
                        child: viewModel.hasMoreMessages
                            ? CircularProgressIndicator()
                            : SizedBox.shrink(),
                      );
                    }
                    return ChatMessageWidget(message: messages[index]);
                  },
                );
              },
            ),
          ),
          ChatInputWidget(
            onSend: (message) {
              viewModel.sendMessage(message);
            },
          ),
        ],
      ),
    );
  }
}