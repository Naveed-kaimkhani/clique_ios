// import 'package:flutter/material.dart';

// class ChatMessageWidget extends StatelessWidget {
//   final Map<String, dynamic> message;

//   const ChatMessageWidget({
//     Key? key,
//     required this.message,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(message['sender']['avatar'] ?? ''),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(message['sender']['name'] ?? '',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(message['text'] ?? ''),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// } 