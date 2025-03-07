// // widgets/chat_input_widget.dart
// import 'package:flutter/material.dart';

// class ChatInputWidget extends StatelessWidget {
//   final Function(String) onSend;

//   const ChatInputWidget({super.key, required this.onSend});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _textController = TextEditingController();

//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Message...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () => onSend(_textController.text),
//           ),
//         ],
//       ),
//     );
//   }
// }

// widgets/chat_input_widget.dart
import 'package:clique/components/send_button.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Assuming you have this file for colors

class ChatInputWidget extends StatelessWidget {
  final Function(String) onSend;

  const ChatInputWidget({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController _textController = TextEditingController();

    return Padding(
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
                border: Border.all(color: Color.fromARGB(255, 214, 211, 211)),
              ),
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
                  // IconButton(
                  //   icon: Icon(Icons.attach_file, color: AppColors.black),
                  //   onPressed: () async {
                  //     // Handle attachment logic here
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          SendButton(
            onSend: () {
           // Retrieve the message text first
              final message = _textController.text;
              // Clear the text field
              _textController.clear();
              // Call the onSend callback with the message
              onSend(message);
            },
          ),
        ],
      ),
    );
  }
}