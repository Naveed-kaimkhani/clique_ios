// import 'package:clique/components/send_button.dart';
// import 'package:clique/models/message_model.dart';
// import 'package:flutter/material.dart';

// class ChatInputWidget extends StatelessWidget {
//   final Function(String) onSend;
//   final MessageModel? replyingTo;
//   final VoidCallback? onCancelReply;
//     ChatInputWidget({
//     required this.onSend,
//     this.replyingTo,
//     this.onCancelReply,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final TextEditingController _textController = TextEditingController();

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: screenWidth * 0.02,
//         horizontal: screenWidth * 0.04,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Color.fromARGB(255, 214, 211, 211)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       decoration: InputDecoration(
//                         hintText: 'Type here...',
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(left: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: screenWidth * 0.03),
//           SendButton(
//             onSend: () {
//            // Retrieve the message text first
//               final message = _textController.text;
//               // Clear the text field
//               _textController.clear();
//               // Call the onSend callback with the message
//               onSend(message);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:clique/components/send_button.dart';
import 'package:clique/models/message_model.dart';
import 'package:clique/view/chat/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String message, MessageModel? replyingTo) onSend;

  ChatInputWidget({required this.onSend});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final ChatViewModel chatViewModel = Get.find<ChatViewModel>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final replied = chatViewModel.repliedMessage.value;
          if (replied == null) return SizedBox();

          return Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Replying to ${replied.sender}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        replied.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => chatViewModel.clearReplyMessage(),
                ),
              ],
            ),
          );
        }),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.02,
            horizontal: screenWidth * 0.04,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border:
                        Border.all(color: Color.fromARGB(255, 214, 211, 211)),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              SendButton(
                onSend: () {
                  final message = _textController.text.trim();
                  if (message.isNotEmpty) {
                    final replyTo = chatViewModel.repliedMessage.value;
                    widget.onSend(message, replyTo);
                    _textController.clear();
                    chatViewModel.clearReplyMessage();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
