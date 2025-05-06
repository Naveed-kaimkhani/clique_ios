// class ChatInputWidget extends StatelessWidget {
//   final Function(String) onSend;
//   final MessageModel? replyingTo;
//   final VoidCallback? onCancelReply;

//   ChatInputWidget({
//     required this.onSend,
//     this.replyingTo,
//     this.onCancelReply,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (replyingTo != null)
//           Container(
//             padding: EdgeInsets.all(8),
//             color: Colors.grey[200],
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text("Replying to: ${replyingTo!.content}"),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: onCancelReply,
//                 ),
//               ],
//             ),
//           ),
//         // Text input and send button...
//       ],
//     );
//   }
// }
