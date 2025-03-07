// // widgets/chat_message_widget.dart
// import 'package:flutter/material.dart';
// import '../models/message_model.dart';

// class ChatMessageWidget extends StatelessWidget {
//   final MessageModel message;

//   const ChatMessageWidget({super.key, required this.message});

//   String _formatTimestamp(int timestamp) {
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//     return "${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: message.isMe ? Colors.blue : Colors.grey[200],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (!message.isMe)
//               Text(
//                 message.sender,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             Text(message.message),
//             SizedBox(height: 8),
//             Text(
//               _formatTimestamp(message.time),
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// widgets/chat_message_widget.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../constants/app_colors.dart'; // Assuming you have this file for colors

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;

  const ChatMessageWidget({super.key, required this.message});

  String _formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat Bubble
          Container(
            width: screenWidth * 0.7,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: message.isMe
                  ? AppColors.appGradientColors // Use your gradient colors
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
                if (!message.isMe)
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      message.sender,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                Text(
                  message.message,
                  style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTimestamp(message.time),
                      style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: message.isMe ? Colors.white : Colors.black),
                    ),
                  ],
                ),
                // Uncomment this if you want to show seen avatars
                // if (message.isMe && message.seenBy.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 5, right: 5),
                //     child: SizedBox(
                //       width: 80,
                //       child: AnimatedAvatarStack(
                //         height: 24,
                //         avatars: [
                //           for (var n = 0; n < message.seenBy.length; n++)
                //             NetworkImage(message.seenBy[n]),
                //         ],
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}